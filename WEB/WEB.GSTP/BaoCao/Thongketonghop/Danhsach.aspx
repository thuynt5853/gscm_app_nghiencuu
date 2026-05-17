<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.Baocao.Thongketonghop.Danhsach" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="../../UI/css/bc/Manager.css" type="text/css" rel="Stylesheet">
	<link href="../../UI/css/bc/TreeView.css" type="text/css" rel="Stylesheet">
    <link href="../../UI/css/bc/bootstrap.css" rel="stylesheet">
	<link href="../../UI/css/bc/common.css" rel="stylesheet">
	<link href="../../UI/css/bc/WebResource.css" type="text/css" rel="stylesheet" class="Telerik_stylesheet">
    <script src="../../UI/js/Common.js"></script>
    <div class="box">
        <div class="box_nd">
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
            </style>
            <div>
                <div runat="server" id="id_show_s" style="display: none; visibility: hidden;">
                </div>
                <div runat="server" id="id_show_ss" style="display: none; visibility: hidden;">
                </div>
            </div>
            








            <div id="TootbalMain">
                <asp:UpdatePanel runat="server" ID="UpdatePanel3">
                    <ContentTemplate>
                        <asp:HiddenField ID="hi_value_send" runat="server" Value="0" />
                        <table border="0px" cellpadding="0px" cellspacing="0px">
                            <tr>
                                <td style="padding-left: 10px; width: 50px; padding-top: 4px;" valign="top">Loại
                                </td>
                                <td style="padding-top: 3px; width: 70px;" valign="top">
                                    <asp:DropDownList ID="Drop_Wasexpre" runat="server" Height="19px">
                                        <asp:ListItem Value="0">Chưa gửi</asp:ListItem>
                                        <asp:ListItem Value="1">Đã gửi</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td style="padding-top: 3px; width: 100px;" valign="top">
                                    <asp:DropDownList ID="Drop_object" runat="server" Height="19px" OnSelectedIndexChanged="Drop_object_SelectedIndexChanged" AutoPostBack="true">
                                        <asp:ListItem Value="H" Text="Cấp huyện"></asp:ListItem>
                                        <asp:ListItem Value="T" Text="Cấp tỉnh"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td style="padding-top: 3px; width: 250px;" valign="top">
                                    <div style="float: left; text-align: right; padding-left: 10px;">
                                        <div style="padding-right: 3px; float: left; padding-top: 2px;">
                                            Báo cáo
                                        </div>
                                        <div style="float: left;">
                                            <asp:DropDownList ID="Drop_Report_Times" runat="server"
                                                Width="120px" Height="19px" DataTextField="TIME_NAME" DataValueField="ID"
                                                CausesValidation="false">
                                            </asp:DropDownList>
                                        </div>
                                        <div style="float: left; cursor: pointer;">
                                            <img alt="" height="18" src="/Resources/Images/table_new.ico" style="border: 0px;"
                                                width="18" />
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr style="height: 50px;" id="Court_selects" runat="server">
                                <td style="text-align: center; color: #000000;" class="Export_District">Tòa án
                                </td>
                                <td colspan="4">
                                    <asp:UpdatePanel runat="server" ID="upload_criminal">
                                        <ContentTemplate>
                                            <asp:TextBox ID="txt_courts_show" ReadOnly="true" ForeColor="Red" runat="server"
                                                Width="400px"></asp:TextBox>




                                            <asp:Button ID="cmd_courts_selects" runat="server" Text="Chọn" OnClientClick="javascript:Show_windows_courts();"
                                                ForeColor="#009900" Width="68px" Height="20px" CssClass="TestingOnliebutton"
                                                OnClick="cmd_courts_selects_Click" />




                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                            <tr runat="server" id="id_chapers_tabales">
                                <td style="text-align: center; color: #000000;">Loại án
                                </td>
                                <td colspan="4">
                                    <asp:TextBox ID="txt_Function_ID" TextMode="MultiLine" ReadOnly="true" ForeColor="Red"
                                        runat="server" Width="400px"></asp:TextBox>





                                    <asp:Button ID="cmd_chapters" runat="server" Text="Chọn" OnClientClick="javascript:Show_windows_functions();"
                                        ForeColor="#009900" Width="60px" Height="20px" CssClass="TestingOnliebutton"
                                        OnClick="cmd_Function_selects_Click" />





                                </td>
                            </tr>
                            <tr style="height: 40px;">
                                <td colspan="5" style="text-align: left; padding-top: 2px; padding-left: 400px;">
                                    <asp:Button ID="cmd_exels" runat="server" Height="20px" Width="68px" CausesValidation="false"
                                        CssClass="TestingOnliebutton" Text="Báo cáo" OnClick="cmd_exels_Click" />
                                    <asp:Button ID="cmd_reset" runat="server" CssClass="TestingOnliebutton" TabIndex="36"
                                        Height="20px" Text="Nhập mới" Width="68px" OnClick="cmd_reset_Click" />
                                </td>
                            </tr>
                            <tr style="margin-top: 100px;">
                                <td style="height: 0px;"></td>
                                <td style=""></td>
                                <td style=""></td>
                                <td style=""></td>
                                <td style=""></td>
                            </tr>
                        </table>
                    </ContentTemplate>
                    <Triggers>
                        <asp:PostBackTrigger ControlID="cmd_exels" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>









            <cc2:ModalPopupExtender ID="MP_Window_courts" runat="server" Y="65" X="2" TargetControlID="id_show_s"
                PopupControlID="P_window_courts" CancelControlID="cmd_close_window_courts" PopupDragHandleControlID="id_header_window_courts"
                BackgroundCssClass="modalBackground" BehaviorID="mpe_courts">
            </cc2:ModalPopupExtender>
            <cc2:ModalPopupExtender ID="MP_Window_Function" runat="server" Y="65" X="2" TargetControlID="id_show_ss"
                PopupControlID="Pl_Chapters" CancelControlID="cmd_close_window_chapters" PopupDragHandleControlID="id_header_window_chapters"
                BackgroundCssClass="modalBackground" BehaviorID="mpe_functions">
            </cc2:ModalPopupExtender>





            <div>
                <asp:Panel ID="P_window_courts" runat="server">
                    <div style="border: solid 1px #8EB4CE; width: 300px; height: 500px; background-color: White; display: block;"
                        class="modalPopup_judge" id="id_window_shows_courts">
                        <div id="id_header_window" class="header_bc" style="width: 300px; cursor: move;">
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
                                    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
                                        <ContentTemplate>
                                            <asp:HiddenField ID="Hi_value_ID_Court" runat="server" />
                                            <asp:HiddenField ID="hi_text_courts" runat="server" />
                                            <asp:HiddenField ID="hi_value_objects" runat="server" />
                                            <asp:HiddenField ID="Show_Court_Cheks" runat="server" />


        <asp:TreeView ID="TreeView_Courts1" runat="server" ShowCheckBoxes="All" ShowLines="true">
        </asp:TreeView>


                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                            </div>
                        </div>
                    </div>
                </asp:Panel>
            </div>



            <div>
                <asp:Panel ID="Pl_Chapters" runat="server">
                    <div style="border: solid 1px #8EB4CE; width: 302px; height: 500px; background-color: White; display: block;"
                        class="modalPopup_judge" id="id_window_shows_functions">
                        <div id="id_header_window_chapters" class="header_bc" style="width: 300px; height: 26px; cursor: move;">
                            <div class="header_bc_title" style="float: left; padding-top: 3px;">
                                Chọn loại án cần báo cáo
                            </div>
                            <div class="head_windowList">
                                <img id="cmd_close_window_chapters" alt="Thoát" src="/UI/img/close_arv.png" onclick="javascript:Hiden_window_functions();" />
                            </div>
                        </div>
                        <div style="clear: both; width: 300px; height: 470px;">
                            <div style="clear: both; height: 471px; overflow: auto; width: 300px;">
                                <div style="padding-left: 25px; padding-top: 10px;">
                                    <asp:UpdatePanel runat="server" ID="UpdatePanel7">
                                        <ContentTemplate>
                                            <asp:HiddenField ID="hi_value_id_functions" runat="server" />




        <asp:TreeView ID="Ra_Functions1" runat="server" ShowCheckBoxes="All" ShowLines="true">
        </asp:TreeView>



                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                            </div>
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </div>
    </div>






    <script type="text/javascript">


        function Hiden_window_courts() {
            $find('mpe_courts').hide();
            document.getElementById('id_window_shows_courts').style.display = 'none';
            return false;
        }
        function Show_windows_courts() {
            //$find('mpe_courts').show();
            //document.getElementById('id_window_shows_courts').style.display = 'block';
            //return false;
            TreeView_OnLoad("<%=TreeView_Courts1.ClientID %>", 1);
        }

        function Hiden_window_functions() {
            $find('mpe_functions').hide();
            document.getElementById('id_window_shows_functions').style.display = 'none';
            //CancelCheck_TreeView_Courts();
            return false;
        }
        function Show_windows_functions() {
            //$find('mpe_functions').show();
            //document.getElementById('id_window_shows_functions').style.display = 'block';
            //return false;
            TreeView_OnLoad("<%=Ra_Functions1.ClientID %>", 2);
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
                TreeView_Courts1_AfterCheck(treeviewID);
            } else if (index === 2) {
                Ra_Functions1_AfterCheck(treeviewID);
            }
        }
        /**
         * Loai bo check node
         * @param treeviewID
         */
        function treeview_Unchecked(treeviewID) {
            //console.log("=> treeview_Unchecked");
            var tv = document.getElementById(treeviewId);
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

        function TreeView_Courts1_AfterCheck(treeviewID) {
            console.log("TreeView_Courts1_AfterCheck");
            document.getElementById('<%= Hi_value_ID_Court.ClientID %>').value = "";
            document.getElementById('<%= hi_text_courts.ClientID %>').value = "";
            document.getElementById('<%= hi_value_objects.ClientID %>').value = "";
            document.getElementById('<%= Show_Court_Cheks.ClientID %>').value = "";
            document.getElementById('<%= txt_courts_show.ClientID %>').value = "";
            
            var r = treeview_GetAllSelected(treeviewID);
            var valueshowid = r[0];
            var valueshotext = r[1];
            console.log("valueshowid: " + valueshowid);
            console.log("valueshotext: " + valueshotext);

            document.getElementById('<%= Hi_value_ID_Court.ClientID %>').value = valueshowid.substring(0, valueshowid.length - 1);
            document.getElementById('<%= hi_value_objects.ClientID %>').value = valueshotext.substring(0, valueshotext.length - 1);
            document.getElementById('<%= hi_text_courts.ClientID %>').value = valueshotext.substring(0, valueshotext.length - 1);
            document.getElementById('<%= Show_Court_Cheks.ClientID %>').value = document.getElementById('<%= hi_value_objects.ClientID %>').value;
            document.getElementById('<%= txt_courts_show.ClientID %>').value = document.getElementById('<%= hi_value_objects.ClientID %>').value;
        }

        function Ra_Functions1_AfterCheck(treeviewID) {
            console.log("Ra_Chapters1_AfterCheck");
            document.getElementById('<%= hi_value_id_functions.ClientID %>').value = "";
            document.getElementById('<%= txt_Function_ID.ClientID %>').value = "";

            var r = treeview_GetAllSelected(treeviewID);
            var valueshowid = r[0];
            var valueshotext = r[1];
            console.log("valueshowid: " + valueshowid);
            console.log("valueshotext: " + valueshotext);

            document.getElementById('<%= hi_value_id_functions.ClientID %>').value = valueshowid.substring(0, valueshowid.length - 1);
            document.getElementById('<%= txt_Function_ID.ClientID %>').value = valueshotext.substring(0, valueshotext.length - 1);
        }
    </script>
</asp:Content>
