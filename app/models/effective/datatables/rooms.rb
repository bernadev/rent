module Effective
  module Datatables
    class Rooms < Effective::Datatable
      datatable do
        table_column :url, width: '5%' do |room|
          css_class = ''
          if room.created_at > Date.today-1.days
            css_class='new-room'
          end
          link_to 'Go', room.url, class: css_class
        end
        table_column :time
        table_column :price
        table_column :status do |room|
          room.status[0,25]
        end
        table_column :requirements do |room|
          room.requirements[0,20]
        end
        table_column :description do |room|
          room.description[0,20]
        end
        table_column :discarded do |room|
          if room.discarded == true
            text = 'uD'
          else
            text = 'D'
          end
#          link_to text, controller: "rooms", action: "togglediscard", id: room.id, remote: true
        end
        table_column :destroy, visible: false, label: 'd' do |room|
          link_to 'x', room, method: :delete, data: { confirm: 'Are you sure?' }
        end
      end

      def collection
        Room.all
      end
    end
  end
end
