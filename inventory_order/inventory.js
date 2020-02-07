var inventory;

(function() {
  inventory = {
    lastId: 0,
    collection: [],
    cacheTemplate: function() {
      var $i_tmpl = $('#inventory_item').remove();
      this.template = Handlebars.compile($i_tmpl.html());
    },
    setDate: function() {
      var date = new Date();
      $('#order_date').text(date.toUTCString());
    },
    get: function(id) {
      var foundItem;

      this.collection.forEach(function(item) {
        if (item.id === id) {
          foundItem = item;
          return false;
        }
      });

      return foundItem;
    },
    remove: function(id) {
      this.collection = this.collection.filter(function(item) {
        return item.id !== id;
      });
    },
    addItem: function() {
      this.lastId += 1;
      var item = {
        id: this.lastId,
        name: '',
        stockNumber: '',
        quantity: 0,
      };
      this.collection.push(item);

      var $item = $(this.template({id: item.id}));
      $('#inventory').append($item);
    },
    updateItem: function(e) {
      var $row = this.findParent(e);
      var item = this.get(this.findId($row));

      item.name = $row.find('input[name^=item_name]').val();
      item.stockNumber = $row.find('input[name^=item_stock_number]').val();
      item.quantity = $row.find('input[name^=item_quantity]').val();
    },
    removeItem: function(e) {
      var $row = this.findParent(e).remove();
      this.remove(this.findId($row));
    },
    findId: function($row) {
      return +$row.find('input[type=hidden]').val();
    },
    findParent: function(e) {
      return $(e.target).closest('tr');
    },
    bindEvents: function() {
      $('#add_item').on('click', this.addItem.bind(this));
      $('#inventory').on('blur', 'input', this.updateItem.bind(this));
      $('#inventory').on('click', 'a.delete', this.removeItem.bind(this));
    },
    init: function() {
      this.setDate();
      this.cacheTemplate();
      this.bindEvents();
    },
  };
})();

$(inventory.init.bind(inventory));
