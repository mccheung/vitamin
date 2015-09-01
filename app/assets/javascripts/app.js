var images = {
    localId: [],
    serverId: []
};

function doSubmit() {
    var content = $('#issue_content').val();
    if(content == "") {
        alert("请描述一下您遇到的问题，更多的信息有助我们进行排查");
        return false;
    } else {
        var elem = document.getElementById('image_ids');
        elem.value = images.serverId;
        images.localId = [];
        images.serverId = [];
        return true;
    }
}

function appendPreviewImg(localId) {
    img = document.createElement('img');
    img.setAttribute('class', 'th');
    img.src = localId;
    img.width = 64;
    img.height = 64;
    document.getElementById('preview_image').appendChild(img);
}

wx.ready(function(){
    document.getElementById('upload_image').onclick = function () {
        wx.chooseImage({
            success: function (res) {
                images.localId = res.localIds;

                var i = 0, length = res.localIds.length;
                function upload() {
                    var localId = res.localIds[i];
                    wx.uploadImage({
                        localId: localId,
                        success: function (res) {
                            images.serverId.push(res.serverId);
                            appendPreviewImg(localId);

                            i++;
                            if (i < length) {
                                upload();
                            }
                        },
                        fail: function (res) {
                            alert(JSON.stringify(res));
                        }
                    });
                }
                upload();
            }
        });
    };

});

wx.error(function (res) {
    alert(res.errMsg);
});
