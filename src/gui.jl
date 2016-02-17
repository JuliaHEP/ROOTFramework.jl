# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

export rootgui


immutable ROOT_GUI
    root_app
    root_timer
    julia_timer
end

_global_root_gui = Nullable{ROOT_GUI}()


ROOT_GUI() = begin
    root_app = icxx"""
        TApplication *app = new TApplication("", 0, 0);
        app->SetReturnFromRun(true);
        app;
    """
    # Timer is necessary, else ROOT's event loop will usually block for a long
    # time (why?). See also the source code of ROOT's TQRootApplication.
    root_timer = icxx"""
        TTimer *timer = new TTimer(20);
        timer->Start(20, false);
        timer;
    """

    julia_timer = Timer(timer::Timer -> root_gui_cycle(), 0, 0.1)
    
    ROOT_GUI(root_app, root_timer, julia_timer)
end


rootgui() = if isnull(_global_root_gui)
    global _global_root_gui = Nullable(ROOT_GUI())
    nothing
end


root_gui_cycle() = icxx"""
    // gApplication->StartIdleing();
    gSystem->InnerLoop();
    // gApplication->StopIdleing();
"""
