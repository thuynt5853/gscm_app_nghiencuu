<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Header.ascx.cs" Inherits="WEB.GSTP.UserControl.Header" %>
<script src="../UI/js/Common.js"></script>
<style>
    .ddlHethong {
        height: 27px;
        line-height: 27px;
        font-weight: bold;
        font-size: 12px;
        color: #ffffff;
        border: solid 1px #db7171;
        padding-left: 10px;
        padding-right: 15px;
        background: url("/UI/img/icoback.png") no-repeat;
        background-position: right 6px center;
        cursor: pointer;
    }

        .ddlHethong option {
            color: #333333;
            text-indent: 24px;
        }
        .MenuLeft_ex_HDSD_menu {
            background-image: url(../UI/img/choice.png);
    background-repeat: no-repeat;
    width: 17px;
    height: 22px;
    /* background-color: #D40627; */
    color: #FFFFFF;
    float: left;
    margin-top: 15px;
        }
        .styleBtn{
            background: none;
            border: none; 
        }
</style>
<div class="header_page">
    <div class="headertop">
        <div class="logo">
            <div class="logo_text">
                <asp:Literal ID="lstHethong" runat="server"></asp:Literal>

                
            </div>
        </div>
        <div class="taikhoan">
            

            <%--<asp:LinkButton ID="LinkButton7" runat="server" ToolTip="Hướng dẫn sử dụng" CssClass="MenuLeft_ex_HDSD_menu" OnClick="cmd_MenuLeft_HDSD_Click" />--%>
            <asp:LinkButton ID="lk_HDSD" runat="server" CssClass="MenuLeft_ex_HDSD_menu" CausesValidation="false" 
            OnClick="lk_HDSD_Click" ToolTip='Hướng dẫn sử dụng' />
            <asp:LinkButton ID="lbtBack" runat="server" ToolTip="Chọn phân hệ"
                CssClass="btnLogout" OnClick="cmbBack_Click" />

            <div class="moduleinfo">
                <div class="dropdown">
                    <a href="javascript:;">
                        <img src="/UI/img/iconPhanhe.png" /></a>

                    <div class="menu_child2">
                        <div class="arrow_up_border"></div>
                        <div class="arrow_up"></div>
                        <ul>
                            <li runat="server" id="liGSTP">
                                <asp:LinkButton ID="LinkButton1" runat="server" CssClass="btnMNGSTP" OnClick="btnGSTP_Click" />

                            </li>
                            <li runat="server" id="liQLA">
                                <asp:LinkButton ID="LinkButton2" runat="server" CssClass="btnMNQLA" OnClick="btnQLA_Click" />

                            </li>
                            <li runat="server" id="liGDT">
                                <asp:LinkButton ID="LinkButton3" runat="server" CssClass="btnMNGDT" OnClick="btnGDT_Click" />

                            </li>
                            <li runat="server" id="liTCCB">
                                <asp:LinkButton ID="LinkButton4" runat="server" CssClass="btnMNTDKT" OnClick="btnTDKT_Click" />

                            </li>
                            <li runat="server" id="liTDKT">
                                <asp:LinkButton ID="LinkButton5" runat="server" CssClass="btnMNTCCB" OnClick="btnTCCB_Click" />

                            </li>
                            <li runat="server" id="liQTHT">
                                <asp:LinkButton ID="LinkButton6" runat="server" CssClass="btnMNQTHT" OnClick="btnQTHT_Click" />

                            </li>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="userinfo">
                <div class="dropdown">
                    <a href="javascript:;" class="dropbtn userinfo_ico">
                        <asp:Literal ID="lstUserName" runat="server"></asp:Literal></a>

                    <div class="menu_child">
                        <div class="arrow_up_border"></div>
                        <div class="arrow_up"></div>
                        <ul>
                            <%-- <li><asp:Literal ID="lstHoten" runat="server"></asp:Literal></li>--%>

                            <li class="singout">
                                <asp:LinkButton ID="lkSigout" runat="server" OnClick="cmdThoat_Click" Text="Đăng xuất"></asp:LinkButton>
                            </li>
                            <li class="changepass"><a href="/ChangePass.aspx">Đổi mật khẩu</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="menu">
        <asp:LinkButton ID="lbtTrangchu" runat="server" CssClass="menubuttonActive"
            Text='Trang chủ' OnClick="cmdTrangchu_Click" />

        <asp:Repeater ID="rptMenu" runat="server" OnItemCommand="rptMenu_ItemCommand">
            <ItemTemplate>
                <asp:LinkButton ID="lbtChuongTrinh"
                    runat="server" CssClass="menubutton" Text='<%#Eval("TEN") %>'
                    CommandName="SELECT" CommandArgument='<%#Eval("MA")+";"+ Eval("DUONGDAN").ToString() %>' />
            </ItemTemplate>
        </asp:Repeater>
        <%-- <a class="menubutton" onclick="dowloadfile()">HDSD</a>--%>
        <%--<asp:LinkButton ID="lk_HDSD" runat="server" CssClass="menubutton" CausesValidation="false" 
            OnClick="lk_HDSD_Click" Text='Hướng dẫn sử dụng' />--%>
    </div>
    <%--<script>
        function dowloadfile() {
            window.location.href = '/HDSD/HDSD HeThongQuanLyAnSoThamPhucTham.docx';
        }</script>--%>
    <div class="searchtop" runat="server" id="divSearch">
        <div class="searchvuan">
            <div style="float: left; margin-top: 17px;">
                <asp:TextBox ID="txtSearch" placeholder="Tên đương sự" onkeypress="return clickButton(event,this.id)" CssClass="textinputsearch" runat="server" Width="115px"></asp:TextBox>
            </div>
            <div style="float: left; margin-left: 1px;">
                <div style="float: left; margin-top: 17px;">
                    <asp:LinkButton ID="lbtTracuu" runat="server" CssClass="buttonTracuu" OnClick="cmdTracuu_Click" />


                </div>
                <div style="float: right; margin-left: 10px;">
                    <asp:LinkButton ID="lbtDanhsach" runat="server" CssClass="btndanhsach" OnClick="cmdDanhsach_Click" />

                    <asp:LinkButton ID="lbtThemmoi" runat="server" CssClass="btnthemmoi" OnClick="cmdThemmoi_Click" />

                </div>
            </div>

            <%--Khai them--%>
            <asp:LinkButton ID="btnDownLoad" CssClass="styleBtn" runat="server" OnClick="btnDownLoad_Click" Visible="true"/>
            <%--//--%>
        </div>
        <div class="vuanghim">
            <div class="vuanghim_info">
                <asp:Literal ID="lttTitleMaVuAn" runat="server" Text="Mã vụ việc:"></asp:Literal>
                <span>
                    <asp:Literal ID="lstMavuan" runat="server"></asp:Literal></span>&nbsp;                
                
                <asp:Literal ID="lstTitleNgay" runat="server" Text="Ngày vụ việc:"></asp:Literal>
                <span>
                    <asp:Literal ID="lstNgayvuan" runat="server"></asp:Literal></span>&nbsp; 
                
                <asp:Literal ID="lttTitleToaAn" runat="server" Text="Tòa án:"></asp:Literal>
                <span>
                    <asp:Literal ID="lstToaan" runat="server"></asp:Literal></span>

                <br />
                <asp:Literal ID="lttTitleVuViec" runat="server" Text="Tên vụ việc:"></asp:Literal>
                <span>
                    <asp:Literal ID="lstTenvuan" runat="server"></asp:Literal></span>
            </div>

            <div style="float: right; width: 115px; margin-right: 1px; margin-top: 5px; position: relative;">
                <asp:LinkButton ID="lbtChitiet" runat="server" Text="Chi tiết vụ án" CssClass="thongtinvuviec" OnClick="cmdChitiet_Click" />

                <div class="inbieumau" id="cmdIn" runat="server">
                    In biểu mẫu                 
                  <div id="wrap">
                      <input type="text" id="searchDMBM" autocomplete="off" onkeyup="searchBieumau()" placeholder="Nhập mã hoặc tên biểu mẫu...">
                      <ul class="navbar" id="navbar">
                          <%-- <asp:Repeater ID="rptBaocao" runat="server">
                              <ItemTemplate>
                                  <li><a href="javascript:;" onclick="popup_BM('<%#Eval("MABM") %>','<%#Eval("DUONGDAN")%>')"><%#Eval("MABM") %> - <%#Eval("TENBM") %></a></li>
                              </ItemTemplate>
                          </asp:Repeater>--%>
                      </ul>
                      <img src="/UI/img/loading-gear.gif" id="imgLoading" runat="server" />
                  </div>
                </div>
            </div>
            <div style="float: right; width: 80px; margin-right: 1px; margin-top: 5px; position: relative; text-align: center;">
                <asp:LinkButton ID="lbtHuyghim" runat="server" Text="Hủy ghim" CssClass="buttonhuyghim" OnClick="cmdHuyghim_Click" />

                <asp:LinkButton ID="lbtTongdat" runat="server" Text="Tống đạt" CssClass="buttontongdat" OnClick="cmdTongdat_Click" />

            </div>
        </div>
    </div>

    <div class="searchtop" runat="server" visible="false" id="divGSTP">
        <div class="searchvuan">
            <div style="float: left;">
                Tên thẩm phán:<asp:TextBox ID="txtTenTP" Style="margin-left: 3px; width: 140px;" CssClass="textinput" onkeypress="return clickcmdTracuuTP(event);" runat="server"></asp:TextBox>
            </div>
            <div style="float: left; margin-left: 3px;">
                <div style="float: left;">
                    <asp:Button ID="cmdTracuuTP" runat="server" CssClass="buttonTracuu" OnClick="cmdTracuuTP_Click" />
                </div>
            </div>
        </div>
        <div class="vuanghim" style="width: 70% !important;">
            <div class="vuanghim_info" style="width: 98%;">
                Tên thẩm phán: <span>
                    <asp:Literal ID="ltrTenThamPhan" runat="server"></asp:Literal></span>&nbsp;&nbsp;&nbsp;                
                Chức danh: <span>
                    <asp:Literal ID="ltrChucDanh" runat="server"></asp:Literal></span> &nbsp;&nbsp;   
               Tòa án: <span>
                   <asp:Literal ID="ltrTenToaAn" runat="server"></asp:Literal></span>
                <br />
                Quyết định bổ nhiệm: <span>
                    <asp:Literal ID="ltrQDBoNhiem" runat="server"></asp:Literal></span>
            </div>
        </div>
    </div>
</div>
<asp:HiddenField ID="hddDonViID" Value="0" runat="server" />
<asp:HiddenField ID="hddLoaiAn" Value="0" runat="server" />
<asp:HiddenField ID="hddGiaidoan" Value="0" runat="server" />
<div class="menuspace"></div>
<script type="text/javascript">
    // Failsafe to prevent endless loading icon
    var loadingHideTimer = null;
    var MAX_LOADING_MS = 2000; // adjust as needed

    function getImgLoading() {
        return $("#<%= imgLoading.ClientID %>");
    }

    function showLoading() {
        var $img = getImgLoading();
        $img.show();
        if (loadingHideTimer) {
            clearTimeout(loadingHideTimer);
        }
        loadingHideTimer = setTimeout(function () {
            $img.hide();
        }, MAX_LOADING_MS);
    }

    function hideLoading() {
        var $img = getImgLoading();
        if (loadingHideTimer) {
            clearTimeout(loadingHideTimer);
            loadingHideTimer = null;
        }
        $img.hide();
    }

    $(document).on('mouseenter', '.inbieumau', function () {
        showLoading();

        var urlBM = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/getBMBAOCAO") %>';
        var d = $('#Header1_hddDonViID').val();
        var l = $('#Header1_hddLoaiAn').val();
        var g = $('#Header1_hddGiaidoan').val();

        $.ajax({
            url: urlBM, data: "{ 'd': '" + d + "','l':'" + l + "','g':'" + g + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
            success: function (data) {
                $('#wrap ul').empty();
                if (data && data.d) {
                    $('#wrap ul').append(data.d);
                }
            }, error: function (response) { }, failure: function (response) { },
            complete: function () {
                hideLoading();
            }
        });
    });

    $(document).on('mouseleave', '.inbieumau', function () {
        hideLoading();
    });
</script>
<script type="text/javascript">
    function clickcmdTracuuTP(e) {
        var keynum;
        if (window.event) // IE
            keynum = e.keyCode;
        else if (e.which) // Netscape/Firefox/Opera
            keynum = e.which;
        if (keynum == 13) {
            document.getElementById('<%=cmdTracuuTP.ClientID %>').click();
            return false;
        }
    }
</script>
<script type="text/javascript">
    function clickButton(e, id) {
        var keynum;
        if (window.event) // IE
            keynum = e.keyCode;
        else if (e.which) // Netscape/Firefox/Opera
            keynum = e.which;

        var txt = document.getElementById(id);
        if (keynum == 13) {
            document.getElementById('<%=lbtTracuu.ClientID %>').click();
            return false;
        }
    }
</script>
<script type="text/javascript">
    function popup_BM(strBM, strLink) {
        var link = "";
        link = strLink + "?BM=" + strBM;
        var width = 800;
        var height = 800;
        PopupReport(link, "Biểu mẫu", width, height);
    }
</script>
<script type="text/javascript">
    function searchBieumau() {
        var input, filter, ul, li, a, i;
        input = document.getElementById('searchDMBM');
        filter = input.value.toUpperCase();

        ul = document.getElementById("navbar");
        li = ul.getElementsByTagName('li');

        // Loop through all list items, and hide those who don't match the search query
        for (i = 0; i < li.length; i++) {

            a = li[i].getElementsByTagName("a")[0];
            if (a.innerHTML.toUpperCase().indexOf(filter) > -1) {
                li[i].style.display = "";
            } else {
                li[i].style.display = "none";
            }
        }
    }
</script>
<script type="text/javascript">
    function PopupReport(pageURL, title, w, h) {
        var left = (screen.width / 2) - (w / 2);
        var top = (screen.height / 2) - (h / 2);
        var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
        return targetWin;
    }
</script>
<script type="text/javascript">
    function CallPopupAHS() {
        var link = "";
        link = "/BaoCao/Thongtinvuviec/HinhSu.aspx";
        var width = 1000;
        var height = 700;
        PopupReport(link, "Thông tin án Hình sự", width, height);
    }
</script>
<script type="text/javascript">
    function CallPopupADS() {
        var link = "/BaoCao/Thongtinvuviec/DanSu.aspx";
        var width = 1000;
        var height = 700;
        PopupReport(link, "Thông tin án Dân sự", width, height);
    }
</script>
<script type="text/javascript">
    function CallPopupAHN() {
        var link = "/BaoCao/Thongtinvuviec/HonNhanGiaDinh.aspx";
        var width = 1000;
        var height = 700;
        PopupReport(link, "Thông tin án Hôn nhân gia đình", width, height);
    }
</script>
<script type="text/javascript">
    function CallPopupAKT() {
        var link = "/BaoCao/Thongtinvuviec/KinhDoanhThuongMai.aspx";
        var width = 1000;
        var height = 700;
        PopupReport(link, "Thông tin án Kinh doanh thương mai", width, height);
    }
</script>
<script type="text/javascript">
    function CallPopupALD() {
        var link = "/BaoCao/Thongtinvuviec/LaoDong.aspx";
        var width = 1000;
        var height = 700;
        PopupReport(link, "Thông tin án Lao động", width, height);
    }
</script>
<script type="text/javascript">
    function CallPopupAHC() {
        var link = "/BaoCao/Thongtinvuviec/HanhChinh.aspx";
        var width = 1000;
        var height = 700;
        PopupReport(link, "Thông tin án Hành chính", width, height);
    }
</script>
<script type="text/javascript">
    function CallPopupAPS() {
        var link = "/BaoCao/Thongtinvuviec/PhaSan.aspx";
        var width = 1000;
        var height = 700;
        PopupReport(link, "Thông tin án Phá sản", width, height);
    }
</script>
<script type="text/javascript">
    function CallPopupBPXLHC() {
        var link = "/BaoCao/Thongtinvuviec/BPXLHC.aspx";
        var width = 1000;
        var height = 700;
        PopupReport(link, "Thông tin án Biện pháp xử lý hành chính", width, height);
    }

    //Khai them
    function DownLoadBM() {
        document.getElementById("Header1_btnDownLoad").click();
    }
    //
</script>