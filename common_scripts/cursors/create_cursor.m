function h = create_cursor(xloc,yl,color,b,handles)
h = line([xloc,xloc],yl,'Tag','cursor','color',color,'ButtonDownFcn',@startDragFcn);

set(gcf,'WindowButtonUpFcn',@stopDragFcn);

    function startDragFcn(varargin)
        if strcmp(get(gcf,'selectiontype'),'alt')
            %myfunc = @(hObject, eventdata) (click_bin_boundary(b,h,handles));
            click_bin_boundary(b,h,handles);
        else
            set(gcf,'WindowButtonMotionFcn',@draggingFcn);
        end
    end

    function draggingFcn(varargin)
        pt = get(gca,'CurrentPoint');
        set(h,'XData',pt(1)*[1,1]);
    end

    function stopDragFcn(varargin)
        set(gcf,'WindowButtonMotionFcn','');
    end
end