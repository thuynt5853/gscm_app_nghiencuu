<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="BaocaoNhapLieu.aspx.cs" Inherits="WEB.GSTP.QLAN.BaocaoNhapLieu" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>
    <script src="../../../../UI/js/Common.js"></script>

    <link href="/UI/css/bc/Manager.css" type="text/css" rel="Stylesheet">
    <link href="/UI/css/bc/TreeView.css" type="text/css" rel="Stylesheet">
    <link href="/UI/css/bc/bootstrap.css" rel="stylesheet">
    <link href="/UI/css/bc/common.css" rel="stylesheet">
    <link href="/UI/css/bc/WebResource.css" type="text/css" rel="stylesheet">

    <style type="text/css">
        .modalBackground {
            background-color: #000;
            filter: alpha(opacity=15);
            opacity: 0.65;
        }

        .align_right {
            text-align: right;
        }

        .phantrang_bottom {
            display: block;
            line-height: 20px;
            margin-bottom: 2px;
            margin-top: 5px;
            overflow: hidden;
            width: 100%;
        }

        .tleboxchung {
            text-transform: uppercase;
        }

        .col1 {
            width: 130px;
        }

        .col2 {
            width: 230px;
        }

        .col3 {
            width: 100px;
        }

        .ajax__calendar_container {
            width: 180px;
        }

        .ajax__calendar_body {
            width: 100%;
            height: 145px;
        }

        .QDVACol1 {
            width: 107px;
        }

        .QDVACol2 {
            width: 270px;
        }

        .QDVACol3 {
            width: 116px;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <div class="boxchung">
                    <table class="table1">

                        <tr style="display: none;">
                            <td>
                                <div>Phạm vi tìm kiếm</div>
                                <asp:DropDownList CssClass="chosen-select" ID="Drop_object" runat="server">
                                    <asp:ListItem Value="TH" Selected="True" Text="Tất cả"></asp:ListItem>
                                    <asp:ListItem Value="TOICAO" Text="Tối cao"></asp:ListItem>
                                    <asp:ListItem Value="CAPCAO" Text="Cấp cao"></asp:ListItem>
                                    <asp:ListItem Value="CAPTINH" Text="Cấp tỉnh"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>

                        <tr>
                            <td style="float: left; width: 100px">Báo cáo </td>
                            <td style="float: left;">
                                <asp:DropDownList ID="ddlLoaiBaocao" CssClass="chosen-select" runat="server" OnSelectedIndexChanged="ddlLoaiBaocao_SelectedIndexChanged" AutoPostBack="true" Width="300px">
                                    <asp:ListItem Value="1" Text=" 1. Báo cáo nhập liệu"></asp:ListItem>
                                    <asp:ListItem Value="2" Text=" 2. Báo cáo xét xử trực tuyến"></asp:ListItem>
                                    <asp:ListItem Value="3" Text=" 3. Báo cáo Kết quả công tác thụ lý giải quyết"></asp:ListItem>
                                    <asp:ListItem Value="4" Text=" 4. Báo cáo giao ban hàng tuần"></asp:ListItem>
                                    <asp:ListItem Value="5" Text=" 5. Báo cáo số liệu kết quả công tác thụ lý, giải quyết theo loại án"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>

                        <tr>
                            <td colspan="1" style="float: left; width: 100px">
                                <asp:Label id="lblThuly_Tungay" runat="server" Text="Thụ lý từ ngày"></asp:Label>
                            </td>
                            <td colspan="1" style="float: left; width: 150px">
                                <asp:TextBox ID="txtThuly_Tu" runat="server" CssClass="user" Width="150px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtThuly_Tu" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtThuly_Tu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <td colspan="1" style="float: left; width: 30px"></td>

                            <td colspan="1" style="float: left; width: 70px">
                                <asp:Label id="lblThuly_Denngay" runat="server" Text="Đến ngày"></asp:Label>
                            </td>
                            <td colspan="1" style="float: left; width: 150px">
                                <asp:TextBox ID="txtThuly_Den" runat="server" CssClass="user" Width="150px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtThuly_Den" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtThuly_Den" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                        </tr>

                        <tr>
                            <td colspan="1" style="display: none; width: 100px">Tình trạng thụ lý</td>
                            <td colspan="1" style="display: none; width: 150px">
                                <asp:DropDownList ID="DropTINHTRANG_THULY" CssClass="chosen-select" runat="server" Width="150px">
                                    <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Đã thụ lý"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Chưa thụ lý"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <asp:Panel runat="server" ID="pnTINHTRANG_GIAIQUYET">
                                <td colspan="1" style="float: left; width: 100px">Tình trạng GQ</td>
                                <td colspan="1" style="float: left; width: 150px">
                                    <asp:DropDownList ID="DropTINHTRANG_GIAIQUYET" CssClass="chosen-select" runat="server" Width="150px">
                                        <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="+ Chưa giải quyết xong"></asp:ListItem>
                                        <asp:ListItem Value="7" Text="+ Đã giải quyết xong"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </asp:Panel>
                        </tr>

                        <tr>
                            <td style="float: left; width: 100px">Chọn đơn vị</td>
                            <td style="float: left; width: 400px">
                                <asp:TextBox ID="txt_courts_show" ReadOnly="true" ForeColor="Red" runat="server" TextMode="MultiLine" Rows="2" Width="400px" CssClass="textbox"></asp:TextBox>
                            </td>
                            <td style="float: left; width: 20px"></td>
                            <td style="float: left; width: 100px">
                                <asp:Button ID="cmd_courts_selects" runat="server" Text="Chọn" OnClientClick="javascript:window_Shows_courts()"
                                    Width="130px" Height="26px" CssClass="buttoninput" OnClick="cmd_courts_selects_Click" />
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <asp:Label ID="lblmsg" runat="server" Style="color: red; float: left; padding-top: 0px; font-size: 15px;"></asp:Label>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <asp:Button ID="cmdPrint" runat="server" CssClass="buttoninput" Text="Báo cáo" OnClientClick="return ValidateInput();" OnClick="cmdPrint_Click" />
                                <asp:Button ID="btn_NhapMoi" runat="server" CssClass="buttoninput" Text="Nhập mới" OnClick="btn_NhapMoi_Click" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>

            <div runat="server" id="id_show_ss" style="display: none; visibility: hidden;"></div>
            <asp:Panel ID="P_window_courts" runat="server">
                <div style="border: solid 1px #8EB4CE; width: 402px; height: 502px; background-color: White; display: block;"
                    class="modalPopup_judge" id="id_window_shows_courts">
                    <div id="id_header_window" class="header_bc" style="cursor: move; width: 400px !important;">
                        <div class="header_bc_title" style="float: left; padding-top: 3px;">
                            Chọn tòa án cần báo cáo
                        </div>
                        <div class="head_windowList">
                            <img id="cmd_close_window_courts" alt="Thoát" src="/UI/img/close_arv.png" onclick="javascript:Hiden_window_courts();" />
                        </div>
                    </div>
                    <div style="clear: both; width: 402px; height: 470px;">
                        <div style="clear: both; height: 471px; overflow: auto; width: 400px;">
                            <div style="padding-left: 25px; padding-top: 10px;">
                                <asp:HiddenField ID="Hi_value_ID_Court" runat="server" />
                                <asp:HiddenField ID="hi_text_courts" runat="server" />
                                <asp:HiddenField ID="hi_value_objects" runat="server" />
                                <asp:HiddenField ID="Show_Court_Cheks" runat="server" />
                                <asp:TreeView ID="TreeView_Courts" runat="server" ShowCheckBoxes="All" ShowLines="true"></asp:TreeView>
                            </div>
                        </div>
                    </div>
                </div>
            </asp:Panel>

        </div>
    </div>


    <cc1:ModalPopupExtender ID="MP_Window_courts" runat="server" Y="100" X="350" TargetControlID="id_show_ss"
        PopupControlID="P_window_courts" CancelControlID="cmd_close_window_courts" PopupDragHandleControlID="id_header_window_courts"
        BackgroundCssClass="modalBackground" BehaviorID="mpe_courts">
    </cc1:ModalPopupExtender>

    <script type="text/javascript">
        function Hiden_window_courts() {
            document.getElementById('id_window_shows_courts').style.display = 'none';
            return false;
        }
        function window_Shows_courts() {
            TreeView_OnLoad("<%=TreeView_Courts.ClientID %>", 1);
        }
        //window.onload = TreeView_OnLoad;
        /**
         * Ham gan su kien cho cac node, duoc goi ngay khi load form xong, gan ham nay vao button goi popup
         */
        function TreeView_OnLoad(treeviewId, index) {
            //console.log("=> TreeView_OnLoad");
            //Treeview id
            var tv = document.getElementById(treeviewId);
            var links = tv.getElementsByTagName("a");
            //Xac dinh parent node
            var isParent = false;
            var divParentId = "";
            for (var i = 0; i < links.length; i++) {
                //Xac dinh the +/- (khong add su kien cho the nay)
                var imgs = links[i].getElementsByTagName("img");
                if (imgs.length === 0) {
                    //Xac dinh checkbox
                    var p = links[i].parentElement;
                    var ip = p.getElementsByTagName("input");
                    //Xac dinh ham da gan truoc do
                    var h = links[i].href;//console.log("h: " + h);
                    var f = h.substring(0, h.indexOf("("));//console.log("f: " + f);
                    //Lay value/text cua node duoc chon
                    var value = h.substring(links[i].href.indexOf(",") + 3, links[i].href.length - 2);
                    var text = links[i].innerHTML;
                    //them su kien cho the link va checkbox, chi gan khi treeview bi load lai, thay ham __doPostBack() bang ham treeview_Click()
                    if (f !== "javascript:treeview_Click") {
                        links[i].setAttribute("href", "javascript:treeview_Click(\"" + tv.id + "\",\"" + ip[0].id + "\",\"" + links[i].id + "\",\"" + value + "\",\"" + text + "\"," + isParent + ",\"" + divParentId + "\",false," + index + ")");
                        ip[0].setAttribute("onclick", "treeview_Click(\"" + tv.id + "\",\"" + ip[0].id + "\",\"" + links[i].id + "\",\"" + value + "\",\"" + text + "\"," + isParent + ",\"" + divParentId + "\",true," + index + ")");
                    }
                    //reset bien danh dau
                    isParent = false;
                    divParentId = "";
                } else {
                    isParent = true;
                    divParentId = links[i].id + "Nodes";
                }
            }
        }
        /**
         * Ham xac dinh xem checkbox hay link duoc nhan de goi ham xu ly tiep theo, tra ve chuoi danh sach duoc chon gom hai phan tu [value, text]
         */
        function treeview_Click(treeviewID, checkboxId, linkId, nodeValue, nodeText, isParent, divParentId, isCheckbox, index) {
            //console.log("=> treeview_Click");
            //console.log("treeviewID: " + treeviewID);
            //console.log("checkboxId: " + checkboxId);
            //console.log("linkId: " + linkId);
            //console.log("nodeValue: " + nodeValue);
            //console.log("nodeText: " + nodeText);
            //console.log("isParent: " + isParent);
            //console.log("isCheckbox: " + isCheckbox);            

            //tu dong chon checkbox neu click link
            if (!isCheckbox) {
                var c = document.getElementById(checkboxId);
                c.checked = !c.checked;
            }
            //Chon cay tu dong
            if (isParent) {
                treeview_ParentChecked(treeviewID, checkboxId, nodeValue, divParentId);
            } else {
                treeview_ChildChecked(treeviewID, checkboxId, nodeValue);
            }
            //Xac dinh node selected
            if (index === 1) {
                //var r = treeview_GetAllSelected(treeviewID)
                //console.log("Nodes selected value: " + r[0]);
                //console.log("Nodes selected text: " + r[1]);
                TreeView_Courts_AfterCheck(treeviewID);
            } else if (index === 2) {
                Ra_Chapters_AfterCheck(treeviewID);
            } else if (index === 3) {
                RT_Cases_AfterCheck(treeviewID);
            } else if (index === 4) {
                RT_Criminals_AfterCheck(treeviewID);
            }
        }
        /**
         * Loai bo check node
         * @param treeviewID
         */
        function treeview_Unchecked(treeviewID) {
            //console.log("=> treeview_Unchecked => treeviewID => " + treeviewID);
            var tv = document.getElementById(treeviewID);
            var ips = tv.getElementsByTagName("input");
            for (var i = 0; i < ips.length; i++) {
                ips[i].checked = false;
            }
        }
        /**
         * Ham checked/uncheck toan bo child node khi parent node duoc chon
         */
        function treeview_ParentChecked(treeviewID, checkboxId, nodeValue, divParentId) {
            //console.log("=> treeview_ParentChecked");
            var tv = document.getElementById(treeviewID);
            var div = document.getElementById(divParentId);
            var ips = div.getElementsByTagName("input");
            var isChecked = document.getElementById(checkboxId).checked;
            for (var i = 0; i < ips.length; i++) {
                ips[i].checked = isChecked;
            }
        }
        /**
         * Ham checked/uncheck parent node khi child node duoc chon
         */
        function treeview_ChildChecked(treeviewID, checkboxId, nodeValue) {
            //console.log("=> treeview_ChildChecked");//nodeValue: 0\\2\\25
            //Kiem tra toan bo nut con cua nut cha chua nut hien tai
            //Neu tat ca check/uncheck thi check/uncheck parent node
            //Tiep tuc de quy voi parent node uncheck

            //-> C1
            //bat dau tu current node
            //tim the div bao toan bo nodes chua node hien tai
            //duyet toan bo node, neu tat ca check/uncheck -> check/uncheck parent node
            //de quy voi parent node, dung lai khi toi root node

            //-> C2
            //bat dau duyet tu root node 
            //goi de quy parent node, khong de quy leaf node
            //duyet toan bo child node cua node hien tai 
            //neu toan bo child node duoc check/uncheck -> check/uncheck parent node
        }
        /**
         * Ham lay danh sach gia tri duoc chon tren treewview, tra ve mang [value,text]
         */
        function treeview_GetAllSelected(treeviewID) {
            //console.log("=> treeview_GetAllSelected");
            var tv = document.getElementById(treeviewID);
            var links = tv.getElementsByTagName("a");
            var values = "";
            var texts = "";
            for (var i = 0; i < links.length; i++) {
                //The +/-
                var imgs = links[i].getElementsByTagName("img");
                if (imgs.length === 0) {
                    //Xac dinh checkbox
                    var p = links[i].parentElement;
                    var ip = p.getElementsByTagName("input");
                    //Lay value/text cua node duoc chon
                    var value_tmp = links[i].href.split(",")[3].replace(/"/g, "").split("\\");
                    var value = value_tmp[value_tmp.length - 1];
                    var text = links[i].innerHTML;
                    if (ip[0].checked) {
                        values = values + value + ",";
                        texts = texts + text + ",";
                    }
                }
            }
            return [values, texts];
        }

        function TreeView_Courts_AfterCheck(treeviewID) {
            console.log("=> TreeView_Courts_AfterCheck");
            document.getElementById('<%= Hi_value_ID_Court.ClientID %>').value = "";
            document.getElementById('<%= hi_text_courts.ClientID %>').value = "";
            document.getElementById('<%= txt_courts_show.ClientID %>').value = "";
            document.getElementById('<%= Show_Court_Cheks.ClientID %>').value = "";

            var r = treeview_GetAllSelected(treeviewID);
            var valueshowid = r[0];
            var valueshotext = r[1];
            //console.log("valueshowid: " + valueshowid);
            //console.log("valueshotext: " + valueshotext);

            document.getElementById('<%= Hi_value_ID_Court.ClientID %>').value = valueshowid.substring(0, valueshowid.length - 1);
            document.getElementById('<%= txt_courts_show.ClientID %>').value = valueshotext.substring(0, valueshotext.length - 1);
            document.getElementById('<%= hi_text_courts.ClientID %>').value = valueshotext.substring(0, valueshotext.length - 1);
            document.getElementById('<%= Show_Court_Cheks.ClientID %>').value = document.getElementById('<%= txt_courts_show.ClientID %>').value;

            //in tat ca gia tri
            console.log("Hi_value_ID_Court: " + document.getElementById('<%= Hi_value_ID_Court.ClientID %>').value);
        }




        function ValidateInput() {
            var txtNgay_Tu = document.getElementById('<%=txtThuly_Tu.ClientID%>');
            if (txtNgay_Tu != null && txtNgay_Den != null) {
                if (!CheckDateTimeControl_KoSoSanhNgayHienTai(txtThuly_Tu, 'từ ngày')) {
                    return false;
                }
                var txtNgay_Den = document.getElementById('<%=txtThuly_Den.ClientID%>');
                if (!CheckDateTimeControl_KoSoSanhNgayHienTai(txtThuly_Den, 'đến ngày')) {
                    return false;
                }
            }
            var txt_courts_show = document.getElementById('<%=txt_courts_show.ClientID%>');
            if (txt_courts_show.value == '') {
                alert('Bạn chưa chọn Tòa án lấy báo cáo');
                return false;
            }
            return true;
        }
    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
