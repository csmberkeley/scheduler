module HomesHelper
    def getPendingBadge(enroll)
        total = 0
        enroll.section.enrolls.each do |enroll| 
            enroll.attendances.each do |attendance|
                if attendance.pending?
                    total += 1
                end
            end
        end
        if total > 0
            return "<span class='badge'>#{total}</span>"
        else
            return ""
        end
    end
end
