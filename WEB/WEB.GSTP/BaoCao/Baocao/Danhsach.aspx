<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.Baocao.Baocao.Danhsach" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <link href="../../UI/css/bc/Manager.css" type="text/css" rel="Stylesheet">
    <link href="../../UI/css/bc/TreeView.css" type="text/css" rel="Stylesheet">
    <link href="../../UI/css/bc/bootstrap.css" rel="stylesheet">
    <link href="../../UI/css/bc/common.css" rel="stylesheet">
    <link href="../../UI/css/bc/WebResource.css" type="text/css" rel="stylesheet">

    <script src="../../UI/js/Common.js"></script>
    <style type="text/css">
        .modalBackground {
            background-color: #000;
            filter: alpha(opacity=15);
            opacity: 0.65;
        }

        .instancse_tips {
            color: #009900;
            font-weight: bold;
        }

        .instancse_seconds {
            color: #11449e;
        }

        input[type=checkbox] + label {
            color: #009900;
            padding-left: 4px;
            font-style: italic;
        }

        input[type=checkbox]:checked + label {
            color: #f00;
            font-style: normal;
        }

        input[type=radio] + label {
            color: #009900;
            padding-left: 4px;
            font-style: italic;
        }

        input[type=radio]:checked + label {
            color: #f00;
            font-style: normal;
        }

        .Radio_4E_div input[type=radio] + label {
            color: #3f90c8;
            /*padding-left: 4px;*/
            font-style: italic;
        }

        .tk_Col1_W {
            width: 75px;
            font-weight: bold;
        }

        .tk_Col2_W {
            width: 170px;
        }

        .tk_Col3_W {
            width: 75px;
            font-weight: bold;
        }

        .tk_Col4_W {
            width: 160px;
        }

        .tk_Col5_W {
            width: 135px;
        }
    </style>

    <div class="box">
        <div class="box_nd">
            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
            <div style="margin-left: 50px; margin-top: 20px;">
                <table class="table1">
                    <tr>
                        <td style="width: 68px;"></td>
                        <td colspan="4" style="width: 500px">
                            <div runat="server" id="Ra_details" style="float: left; height: 25px; padding-bottom: 10px;">
                                <asp:RadioButtonList ID="Ra_Detail_Total" runat="server" Font-Bold="True" ForeColor="#009900"
                                    RepeatDirection="Horizontal" CellPadding="5">
                                    <asp:ListItem Text="Tổng hợp" Selected="True" Value="0"></asp:ListItem>
                                    <asp:ListItem Text="Chi tiết " Value="1"></asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                            <div runat="server" id="Ra_level_tr_div" style="float: left; height: 25px; padding-bottom: 10px;">
                                <asp:RadioButtonList ID="Ra_level_trial" runat="server" Font-Bold="True" ForeColor="#009900"
                                    RepeatDirection="Horizontal" CellPadding="5">
                                    <asp:ListItem Text="Theo tỉnh" Selected="True" Value="0"></asp:ListItem>
                                    <asp:ListItem Text="Cấp xét xử" Value="1"></asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="4" style="width: 500px;">
                            <div style="float: right; padding-right: 25px; height: 35px; padding-bottom: 10px;">
                                <asp:CheckBox ID="ch_options_TD" Font-Bold="true" ForeColor="Blue" runat="server"
                                    Text="Theo tội danh" />
                            </div>
                        </td>
                        <td></td>
                    </tr>
                    <tr runat="server" id="contai_4E_tr">
                        <td></td>
                        <td colspan="4">
                            <div class="Radio_4E_div" style="float: left; padding-right: 25px; height: 35px; padding-bottom: 10px;">
                                <asp:RadioButtonList ID="Radio_4E" runat="server" RepeatDirection="Horizontal" Width="480px" ToolTip="Các lựa chọn trên chỉ có tác dụng với những báo cáo chi tiết có hiển thị mã ngành được chọn ở phía trên; nếu chọn là mặc định (bỏ qua) nghĩa là hủy 02 lựa chọn cùng dòng này.">
                                    <asp:ListItem Value="0" Selected="True">Mặc định</asp:ListItem>
                                    <asp:ListItem Value="1">Cha của mã ngành</asp:ListItem>
                                    <asp:ListItem Value="2">Loại hình doanh nghiệp</asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <asp:DropDownList ID="Drop_Skin" CssClass="chosen-select" runat="server" Width="156px" OnSelectedIndexChanged="Drop_Skin_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                        </td>
                        <td colspan="2">
                            <asp:DropDownList ID="Drop_Options" CssClass="chosen-select" runat="server" Width="219px" OnSelectedIndexChanged="Drop_Options_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                        </td>
                        <td class="tk_Col5_W">
                            <asp:DropDownList ID="Drop_object" CssClass="chosen-select" runat="server" Width="130px" OnSelectedIndexChanged="Drop_object_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td class="tk_Col1_W">Từ ngày</td>
                        <td class="tk_Col2_W">
                            <asp:TextBox ID="txt_day_from" runat="server" TabIndex="3" Height="26px" CssClass="user" Width="155px" MaxLength="10"></asp:TextBox>
                            <cc2:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txt_day_from" Format="dd/MM/yyyy" Enabled="true" />
                            <cc2:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txt_day_from" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                        <td class="tk_Col3_W">Đến ngày</td>
                        <td class="tk_Col4_W">
                            <asp:TextBox ID="txt_day_to" runat="server" Height="26px" CssClass="user" Width="143px" MaxLength="10"></asp:TextBox>
                            <cc2:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txt_day_to" Format="dd/MM/yyyy" Enabled="true" />
                            <cc2:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txt_day_to" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                        <td colspan="2"></td>
                    </tr>
                    <tr>
                        <td class="tk_Col1_W">Tòa án</td>
                        <td colspan="3">
                            <asp:TextBox ID="txt_courts_show" CssClass="user" ReadOnly="true" ForeColor="Red" runat="server" Height="26px" Width="387px"></asp:TextBox>
                        </td>
                        <td>
                            <asp:Button ID="cmd_courts_selects" runat="server" Text="Chọn" OnClientClick="javascript:window_Shows_courts()"
                                Width="130px" Height="26px" CssClass="buttoninput" OnClick="cmd_courts_selects_Click" />
                        </td>
                        <td></td>
                    </tr>
                    <tr runat="server" id="id_chapers_tabales">
                        <td class="tk_Col1_W">Chương</td>
                        <td colspan="3">
                            <asp:TextBox ID="txt_chapters" CssClass="user" TextMode="MultiLine" ReadOnly="true" ForeColor="Red" runat="server" Height="40px" Width="387px"></asp:TextBox>
                        </td>
                        <td>
                            <asp:Button ID="cmd_chapters" runat="server" Text="Chọn" OnClientClick="javascript:document.getElementById('id_window_shows_chapters').style.display = 'block';"
                                Height="26px" Width="130px" CssClass="buttoninput" OnClick="cmd_chapters_selects_Click" />
                        </td>
                        <td></td>
                    </tr>
                    <tr runat="server" id="id_criminal_tabales">
                        <td class="tk_Col1_W">Tội danh</td>
                        <td colspan="3">
                            <asp:TextBox ID="txt_crimial_show" CssClass="user" ReadOnly="true" TextMode="MultiLine" ForeColor="Red" runat="server" Width="387px" Height="40px"></asp:TextBox>
                        </td>
                        <td>
                            <asp:Button ID="cmd_crimial_selects" runat="server" Text="Chọn" OnClientClick="javascript:document.getElementById('id_window_shows_criminal').style.display = 'block';"
                                Height="26px" Width="130px" CssClass="buttoninput" OnClick="cmd_crimial_select_Click" />
                        </td>
                        <td></td>
                    </tr>
                    <tr runat="server" id="id_cases_tabales" visible="false">
                        <td class="tk_Col1_W">Vụ việc</td>
                        <td colspan="3">
                            <asp:TextBox ID="txt_Case_shows" CssClass="user" ReadOnly="true" TextMode="MultiLine" ForeColor="Red" runat="server" Width="387px" Height="40px"></asp:TextBox>
                        </td>
                        <td>
                            <asp:Button ID="cmd_case_select" runat="server" Text="Chọn" OnClientClick="javascript:document.getElementById('id_window_shows_Cases').style.display = 'block';"
                                Height="26px" Width="130px" CssClass="buttoninput" OnClick="cmd_case_select_Click" />
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="5">
                            <span style="padding-top: 5px; color: red;">
                                <asp:Label ID="lb_Messages" Text="" runat="server"></asp:Label></span>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="4">
                            <div style="float: right; padding-top: 15px; padding-bottom: 8px;">
                                <asp:Button ID="cmd_exels" runat="server" CssClass="buttoninput" TabIndex="36"
                                    Height="26px" Text="Báo cáo" Width="68px" OnClick="cmd_Ok_s_Click" />
                                <asp:Button ID="cmd_reset" runat="server" CssClass="buttoninput" TabIndex="36"
                                    Height="26px" Text="Nhập mới" Width="68px" OnClick="cmd_reset_Click" />
                            </div>
                            <div style="padding-left: 65px; padding-top: 10px;" id="id_show_check" runat="server">
                                <div style="float: left; display: none;">
                                    <asp:CheckBox ID="ch_dear" runat="server" ForeColor="DarkGoldenrod" Text="Lấy số liệu tử hình" />
                                </div>
                                <div style="float: left; padding-left: 10px; display: none;">
                                    <asp:CheckBox ID="ch_young" runat="server" Font-Bold="False" ForeColor="DarkGoldenrod"
                                        Text="Lấy số liệu chung thân" />
                                </div>
                            </div>
                        </td>
                        <td></td>
                    </tr>
                </table>
            </div>
            <div runat="server" id="id_show_s" style="display: none; visibility: hidden;"></div>
            <div runat="server" id="id_show_ss" style="display: none; visibility: hidden;"></div>
            <div runat="server" id="id_show_sss" style="display: none; visibility: hidden;"></div>
            <div runat="server" id="id_show_ssss" style="display: none; visibility: hidden;"></div>

            <asp:Panel ID="P_window_courts" runat="server">
                <div style="border: solid 1px #8EB4CE; width: 302px; height: 500px; background-color: White; display: block;"
                    class="modalPopup_judge" id="id_window_shows_courts">
                    <div id="id_header_window" class="header_bc" style="cursor: move; width: 300px !important;">
                        <div class="header_bc_title" style="float: left; padding-top: 3px;">
                            Chọn tòa án cần báo cáo
                        </div>
                        <div class="head_windowList">
                            <img id="cmd_close_window_courts" alt="Thoát" src="/UI/img/close_arv.png" onclick="javascript:Hiden_window_courts();" />
                        </div>
                    </div>
                    <div style="clear: both; width: 300px; height: 470px;">
                        <div style="clear: both; height: 471px; overflow: auto; width: 300px;">
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
            <asp:Panel ID="P_Window_Criminal" runat="server">
                <div style="border: solid 1px #8EB4CE; width: 302px; height: 500px; background-color: White; display: block;"
                    class="modalPopup_judge" id="id_window_shows_criminal">
                    <div id="id_header_window_criminal" class="header_bc" style="width: 300px; height: 26px; cursor: move;">
                        <div class="header_bc_title" style="float: left; padding-top: 3px;">
                            Chọn tội danh cần báo cáo
                        </div>
                        <div class="head_windowList">
                            <img id="cmd_close_window_criminal" alt="Thoát" src="/UI/img/close_arv.png"
                                onclick="javascript:Hiden_window_criminal();" />
                        </div>
                    </div>
                    <div style="clear: both; width: 300px; height: 470px;">
                        <div style="clear: both; height: 471px; overflow: auto; width: 300px;">
                            <div style="padding-left: 25px; padding-top: 10px;">
                                <asp:HiddenField ID="hi_value_id_criminal" runat="server" />
                                <asp:HiddenField ID="hi_txt_crimial" runat="server" />
                                <asp:TreeView ID="RT_Criminals" runat="server" ShowCheckBoxes="All" ShowLines="true"></asp:TreeView>
                            </div>
                        </div>
                    </div>
                </div>
            </asp:Panel>
            <asp:Panel ID="Pl_Chapters" runat="server">
                <div style="border: solid 1px #8EB4CE; width: 302px; height: 500px; background-color: White; display: block;"
                    class="modalPopup_judge" id="id_window_shows_chapters">
                    <div id="id_header_window_chapters" class="header_bc" style="width: 300px; height: 26px; cursor: move;">
                        <div class="header_bc_title" style="float: left; padding-top: 3px;">
                            Chọn chương cần báo cáo
                        </div>
                        <div class="head_windowList">
                            <img id="cmd_close_window_chapters" alt="Thoát" src="/UI/img/close_arv.png"
                                onclick="javascript:Hiden_window_chapters();" />
                        </div>
                    </div>
                    <div style="clear: both; width: 300px; height: 470px;">
                        <div style="clear: both; height: 471px; overflow: auto; width: 300px;">
                            <div style="padding-left: 25px; padding-top: 10px;">
                                <asp:HiddenField ID="hi_value_id_chapters" runat="server" />
                                <asp:HiddenField ID="hi_txt_chapters" runat="server" />
                                <asp:TreeView ID="Ra_Chapters" runat="server" ShowCheckBoxes="All" ShowLines="true"></asp:TreeView>
                            </div>
                        </div>
                    </div>
                </div>
            </asp:Panel>
            <asp:Panel ID="P_Window_Cases" runat="server">
                <div style="border: solid 1px #8EB4CE; width: 302px; height: 500px; background-color: White; display: block;"
                    class="modalPopup_judge" id="id_window_shows_Cases">
                    <div id="id_header_window_Cases" class="header_bc" style="width: 300px; height: 26px; cursor: move;">
                        <div class="header_bc_title" style="float: left; padding-top: 3px;">
                            Chọn Loại án, vụ việc cần báo cáo
                        </div>
                        <div class="head_windowList">
                            <img id="cmd_close_window_Cases" alt="Thoát" src="/UI/img/close_arv.png" onclick="javascript:Hiden_window_Cases();" />
                        </div>
                    </div>
                    <div style="clear: both; width: 300px; height: 470px;">
                        <div style="clear: both; height: 471px; overflow: auto; width: 300px;">
                            <div style="padding-left: 25px; padding-top: 10px;">
                                <asp:HiddenField ID="hi_value_id_Cases" runat="server" />
                                <asp:HiddenField ID="hi_txt_Case" runat="server" />
                                <asp:TreeView ID="RT_Cases" runat="server" ShowCheckBoxes="All" ShowLines="true"></asp:TreeView>
                            </div>
                        </div>
                    </div>
                </div>
            </asp:Panel>

        </div>
    </div>

    <cc2:ModalPopupExtender ID="MP_Window_courts" runat="server" Y="250" X="250" TargetControlID="id_show_ss"
        PopupControlID="P_window_courts" CancelControlID="cmd_close_window_courts" PopupDragHandleControlID="id_header_window_courts"
        BackgroundCssClass="modalBackground" BehaviorID="mpe_courts">
    </cc2:ModalPopupExtender>
    <cc2:ModalPopupExtender ID="MP_Window_Criminal" runat="server" Y="250" X="250" TargetControlID="id_show_s"
        PopupControlID="P_Window_Criminal" CancelControlID="cmd_close_window_criminal" PopupDragHandleControlID="id_header_window_criminal"
        BackgroundCssClass="modalBackground" BehaviorID="mpe_criminal">
    </cc2:ModalPopupExtender>
    <cc2:ModalPopupExtender ID="MP_Window_Chapters" runat="server" Y="250" X="250" TargetControlID="id_show_ssss"
        PopupControlID="Pl_Chapters" CancelControlID="cmd_close_window_chapters" PopupDragHandleControlID="id_header_window_chapters"
        BackgroundCssClass="modalBackground" BehaviorID="mpe_chapters">
    </cc2:ModalPopupExtender>
    <cc2:ModalPopupExtender ID="MP_Window_Cases" runat="server" Y="250" X="250" TargetControlID="id_show_sss"
        PopupControlID="P_window_Cases" CancelControlID="cmd_close_window_Cases" PopupDragHandleControlID="id_header_window_Cases"
        BackgroundCssClass="modalBackground" BehaviorID="mpe_Cases">
    </cc2:ModalPopupExtender>

    <script type="text/javascript">

        function Hiden_window_courts() {
            document.getElementById('id_window_shows_courts').style.display = 'none';
            return false;
        }
        function Hiden_window_Cases() {
            document.getElementById('id_window_shows_Cases').style.display = 'none';
            return false;
        }

        function Hiden_window_criminal() {
            document.getElementById('id_window_shows_criminal').style.display = 'none';
            return false;
        }
        function Hiden_window_chapters() {
            document.getElementById('id_window_shows_chapters').style.display = 'none';
            return false;
        }

        function window_Shows_courts() {
            TreeView_OnLoad("<%=TreeView_Courts.ClientID %>", 1);
        }
        function window_Shows_chapters() {
            document.getElementById('id_window_shows_chapters').style.display = 'block';
            TreeView_OnLoad("<%=Ra_Chapters.ClientID %>", 2);
        }
        function window_Shows_cases() {
            document.getElementById('id_window_shows_Cases').style.display = 'block';
            TreeView_OnLoad("<%=RT_Cases.ClientID %>", 3);
            return false;
        }
        function window_Shows_criminals() {
            document.getElementById('id_window_shows_criminal').style.display = 'block';
            TreeView_OnLoad("<%=RT_Criminals.ClientID %>", 4);
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
            console.log("hi_value_id_chapters: " + document.getElementById('<%= hi_value_id_chapters.ClientID %>').value);
            console.log("hi_value_id_criminal: " + document.getElementById('<%= hi_value_id_criminal.ClientID %>').value);
            console.log("hi_value_id_Cases: " + document.getElementById('<%= hi_value_id_Cases.ClientID %>').value);
        }

        function Ra_Chapters_AfterCheck(treeviewID) {
            console.log("=> Ra_Chapters_AfterCheck");
            document.getElementById('<%= hi_value_id_chapters.ClientID %>').value = "";
            document.getElementById('<%= hi_txt_chapters.ClientID %>').value = "";
            document.getElementById('<%= txt_chapters.ClientID %>').value = "";

            var r = treeview_GetAllSelected(treeviewID);
            var valueshowid = r[0];
            var valueshotext = r[1];
            //console.log("valueshowid: " + valueshowid);
            //console.log("valueshotext: " + valueshotext);

            document.getElementById('<%= hi_value_id_chapters.ClientID %>').value = valueshowid.substring(0, valueshowid.length - 1);
            document.getElementById('<%= hi_txt_chapters.ClientID %>').value = valueshotext.substring(0, valueshotext.length - 1);
            document.getElementById('<%= txt_chapters.ClientID %>').value = valueshotext.substring(0, valueshotext.length - 1);

            //in tat ca gia tri
            console.log("Hi_value_ID_Court: " + document.getElementById('<%= Hi_value_ID_Court.ClientID %>').value);
            console.log("hi_value_id_chapters: " + document.getElementById('<%= hi_value_id_chapters.ClientID %>').value);
            console.log("hi_value_id_criminal: " + document.getElementById('<%= hi_value_id_criminal.ClientID %>').value);
            console.log("hi_value_id_Cases: " + document.getElementById('<%= hi_value_id_Cases.ClientID %>').value);
        }
        function RT_Criminals_AfterCheck(treeviewID) {
            console.log("=> RT_Criminals_AfterCheck");
            document.getElementById('<%= hi_value_id_criminal.ClientID %>').value = "";
            document.getElementById('<%= hi_txt_crimial.ClientID %>').value = "";
            document.getElementById('<%= txt_crimial_show.ClientID %>').value = "";

            var r = treeview_GetAllSelected(treeviewID);
            var valueshowid = r[0];
            var valueshotext = r[1];
            //console.log("valueshowid: " + valueshowid);
            //console.log("valueshotext: " + valueshotext);

            document.getElementById('<%= hi_value_id_criminal.ClientID %>').value = valueshowid.substring(0, valueshowid.length - 1);
            document.getElementById('<%= hi_txt_crimial.ClientID %>').value = valueshotext.substring(0, valueshotext.length - 1);
            document.getElementById('<%= txt_crimial_show.ClientID %>').value = valueshotext.substring(0, valueshotext.length - 1);

            //in tat ca gia tri
            console.log("Hi_value_ID_Court: " + document.getElementById('<%= Hi_value_ID_Court.ClientID %>').value);
            console.log("hi_value_id_chapters: " + document.getElementById('<%= hi_value_id_chapters.ClientID %>').value);
            console.log("hi_value_id_criminal: " + document.getElementById('<%= hi_value_id_criminal.ClientID %>').value);
            console.log("hi_value_id_Cases: " + document.getElementById('<%= hi_value_id_Cases.ClientID %>').value);
        }
        function RT_Cases_AfterCheck(treeviewID) {
            console.log("=> RT_Cases_AfterCheck");
            document.getElementById('<%= hi_value_id_Cases.ClientID %>').value = "";
            document.getElementById('<%= hi_txt_Case.ClientID %>').value = "";
            document.getElementById('<%= txt_Case_shows.ClientID %>').value = "";

            var r = treeview_GetAllSelected(treeviewID);
            var valueshowid = r[0];
            var valueshotext = r[1];
            //console.log("valueshowid: " + valueshowid);
            //console.log("valueshotext: " + valueshotext);

            document.getElementById('<%= hi_value_id_Cases.ClientID %>').value = valueshowid.substring(0, valueshowid.length - 1);
            document.getElementById('<%= hi_txt_Case.ClientID %>').value = valueshotext.substring(0, valueshotext.length - 1);
            document.getElementById('<%= txt_Case_shows.ClientID %>').value = valueshotext.substring(0, valueshotext.length - 1);

            //in tat ca gia tri
            console.log("Hi_value_ID_Court: " + document.getElementById('<%= Hi_value_ID_Court.ClientID %>').value);
            console.log("hi_value_id_chapters: " + document.getElementById('<%= hi_value_id_chapters.ClientID %>').value);
            console.log("hi_value_id_criminal: " + document.getElementById('<%= hi_value_id_criminal.ClientID %>').value);
            console.log("hi_value_id_Cases: " + document.getElementById('<%= hi_value_id_Cases.ClientID %>').value);
        }
    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
