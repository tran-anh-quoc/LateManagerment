var commonFunc = {
    deleteLink: function(data) {
        if (data.deleteLink != null) {
            $('<a>', {
                'data-method': 'delete',
                href: data.deleteLink,
                rel: 'nofollow'
            }).appendTo('#container').click();
        }
    },
    updateLink: function(data) {
        if (data.form != null) {
            data.form.submit();
        }
    }
};

var confirmDialog = {
    $dialog: null,
    $yesBtn: null,
    data: null,
    callback: null,

    init: function() {
        this.$dialog = $('#confirmModal');

        var self = this;
        this.$dialog.find("button.yes").on('click', function() {
            if (self.callback != null) {
                self.callback(self.data);
            }
        });
    },
    show: function(message) {
        this.$dialog.find('.modal-body').text(message);
        this.$dialog.modal({
            backdrop: 'static'
        })
    }
};

$(document).ready( function() {
    confirmDialog.init();

    // config confirm dialog for update links
    $('.update-link').on('click', function(e) {
        e.preventDefault();
        confirmDialog.data = { form: $(this).closest('form') };
        confirmDialog.callback = commonFunc.updateLink;

        confirmDialog.show($(this).attr('data-message'));
    });

    // config confirm dialog for delete links
    $('.delete-link').on('click', function(e) {
        e.preventDefault();
        confirmDialog.data = { deleteLink: $(this).attr('data-link') };
        confirmDialog.callback = commonFunc.deleteLink;

        confirmDialog.show($(this).attr('data-message'));
    });
});
