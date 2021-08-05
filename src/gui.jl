# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

cxxinclude("TSystem.h")
cxxinclude("TApplication.h")

export rootgui


struct ROOT_GUI
    root_app
    root_timer
    julia_timer
end

_global_root_gui = nothing


function ROOT_GUI()
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

    julia_timer = Timer(timer::Timer -> root_gui_cycle(), 0, interval=0.1)
    
    ROOT_GUI(root_app, root_timer, julia_timer)
end


rootgui() = if isnothing(_global_root_gui)
    global _global_root_gui = ROOT_GUI()
    nothing
end


function root_gui_cycle()
    rootgui()
    icxx"""
        // gApplication->StartIdleing();
        gSystem->InnerLoop();
        // gApplication->StopIdleing();
    """
end
