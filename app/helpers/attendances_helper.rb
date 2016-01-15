module AttendancesHelper
    def item_class(attendance)
        if attendance.nil?
            return "list-group-item-danger"
        elsif attendance.approved?
            return "list-group-item-success"
        elsif attendance.excused?
            return "list-group-item-info"
        elsif attendance.pending?
            return "list-group-item-warning"
        else
            return "list-group-item-danger"
        end
    end
end
