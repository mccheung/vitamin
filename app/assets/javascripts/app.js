var images = {
  localId: [],
  serverId: []
};

function doSubmit() {
  var itemName = document.getElementById('item_name').value;
  if(itemName == "") {
    alert("请输入物品名称");
    return false;
  } else {
    var elem = document.getElementById('media_ids');
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
  document.getElementById('scan_qrcode').onclick = function () {
    wx.scanQRCode({
      needResult: 1, // 默认为0，扫描结果由微信处理，1则直接返回扫描结果，
      scanType: ["qrCode","barCode"], // 可以指定扫二维码还是一维码，默认二者都有
      success: function (res) {
        var result = res.resultStr; // 当needResult 为 1 时，扫码返回的结果
        console.info(result);
      }
    });
  };
  
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
