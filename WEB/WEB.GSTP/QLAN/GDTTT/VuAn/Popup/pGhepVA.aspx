<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pGhepVA.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.Popup.pGhepVA" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Ghép đơn vào vụ án</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
</head>
<body>
    <style type="text/css">
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
            overflow-y: auto;
            overflow-x: auto;
        }
        .table_info_va td:nth-child(2),.table_info_va td:nth-child(4),.table_info_va td:nth-child(6){font-weight:bold;}
    </style>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hddReloadParent" Value="0" runat="server" />
                <div class="boxchung" style="margin-bottom: 10px">
                    <h4 class="tleboxchung">Thông tin đơn</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table_info_va">
                            <tr>
                                <td style="width: 100px;">Số CV chuyển</td>
                                <td style="width: 150px;">
                                    <asp:Literal ID="lttDon_SoCV" runat="server"></asp:Literal>
                                </td>

                                <td style="width: 100px;">Ngày CV chuyển</td>
                                <td style="width: 150px;">
                                    <asp:Literal ID="lttDon_NgayCV" runat="server"></asp:Literal>
                                </td>
                                <!--------------------------->
                                <td style="width: 100px">Số thụ lý</td>
                                <td style="width: 150px;">
                                    <asp:Literal ID="lttDon_SoThuLy" runat="server"></asp:Literal>
                                </td>
                                <td style="width: 100px">Ngày thụ lý</td>
                                <td>
                                    <asp:Literal ID="lttDon_NgayThuLy" runat="server"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td>Số BA/QĐ</td>
                                <td>
                                    <asp:Literal ID="lttDon_SoBA" runat="server"></asp:Literal>
                                </td>
                                <td>Ngày BA/QĐ</td>
                                <td>
                                    <asp:Literal ID="lttDon_NgayBA" runat="server"></asp:Literal>
                                </td>
                                <!----------------->
                                <td>Tòa án ra BA/QD</td>
                                <td colspan="3">
                                    <asp:Literal ID="lttDon_ToaXX" runat="server"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td>Người đề nghị, KN, TB</td>
                                <td colspan="7">
                                    <asp:Literal ID="lttDon_NguoiGui" runat="server"></asp:Literal>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="boxchung">
                    <h4 class="tleboxchung">Vụ án được chọn</h4>
                    <div class="boder" style="padding: 10px;">
                        <asp:Panel ID="pnVuAn" runat="server">
                            <table class="table_info_va">
                                <tr>
                                    <td style="width: 110px;">Vụ án:</td>
                                    <td colspan="3" style="vertical-align: top;">
                                        <asp:Literal ID="txtTenVuan" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Số thụ lý:</td>
                                    <td style="width: 250px;">
                                        <asp:Literal ID="txtVuAn_SoThuLy" runat="server"></asp:Literal>
                                    </td>
                                    <td style="width: 105px">Ngày thụ lý:</td>
                                    <td>
                                        <asp:Literal ID="txtVuAn_NgayThuLy" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="lttNguyenDon" runat="server" Text="Nguyên đơn/ Người khởi kiện:"></asp:Literal></td>
                                    <td style="vertical-align: top;">
                                        <asp:Literal ID="txtVuAn_NguyenDon" runat="server"></asp:Literal>
                                    </td>
                                    <td>
                                        <asp:Literal ID="lttBiDon" runat="server" Text="Bị đơn/ Người  bị kiện:"></asp:Literal></td>
                                    <td style="vertical-align: top;">
                                        <asp:Literal ID="txtVuAn_BiDon" runat="server"></asp:Literal>
                                    </td>
                                </tr>


                                <tr>
                                    <td>Tòa xử phúc thẩm</td>
                                    <td colspan="3">
                                        <asp:Literal ID="lttToaXuPT" runat="server"></asp:Literal></td>
                                </tr>
                                <tr>
                                    <td>Số BA/QĐ phúc thẩm</td>
                                    <td>
                                        <asp:Literal ID="txtVuAn_SoBanAn" runat="server"></asp:Literal>
                                    </td>
                                    <td>Ngày BA/QĐ phúc thẩm</td>
                                    <td>
                                        <asp:Literal ID="txtVuAn_NgayBanAn" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <asp:Literal ID="lttOther" runat="server"></asp:Literal>

                            </table>
                            <div style="width: 50%; margin-left: 125px;">
                                <asp:Button ID="cmdSave" runat="server" CssClass="buttoninput"
                                    Text="Ghép vụ án" OnClientClick="return validate();" OnClick="cmdSave_Click" />
                                <input type="button" class="buttoninput" onclick="ClosePopup();" value="Đóng" />
                            </div>
                        </asp:Panel>
                        <div style="width: 96%; margin: 5px 2%;">
                            <asp:Literal ID="lttMsg" runat="server"></asp:Literal>
                        </div>
                    </div>
                </div>
                <div class="boxchung">
                    <h4 class="tleboxchung">Tìm vụ án</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">

                            <tr>
                                <td class="DonGDTCol1">Tòa ra BA/QĐ</td>
                                <td class="DonGDTCol2">
                                    <asp:DropDownList ID="ddlToaXetXu" CssClass="chosen-select"
                                        runat="server" Width="230px">
                                    </asp:DropDownList>
                                </td>
                                <td class="DonGDTCol3">Số BA/QĐ</td>
                                <td class="DonGDTCol4">
                                    <asp:TextBox ID="txtSoQDBA" runat="server" CssClass="user" Width="152px" MaxLength="50"></asp:TextBox>
                                </td>
                                <td class="DonGDTCol5">Ngày BA/QĐ</td>
                                <td>
                                    <asp:TextBox ID="txtNgayBAQD" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayBAQD" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayBAQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                    <asp:Button ID="cmdTimkiem" runat="server"
                                        CssClass="buttoninput" Text="Tìm kiếm"
                                        OnClientClick="return validate_search();" OnClick="lbtimkiem_Click" />
                                    
                                 
                                    <span style="margin-left: 5px;">   <asp:Button ID="cmdThemVA" runat="server"
                                        CssClass="buttoninput" Text="Thêm vụ án" OnClick="cmdThemVA_Click" />
                                        </span>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6">
                                    <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6">
                                    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                                    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                                    <asp:HiddenField ID="hddChoiceVuAn" Value="0" runat="server" />


                                    <div class="phantrang">
                                        <div class="sobanghi">
                                            <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                        </div>
                                        <div class="sotrang">
                                            <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                                OnClick="lbTBack_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                            <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                            <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                            <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                                OnClick="lbTNext_Click"></asp:LinkButton>
                                            <asp:DropDownList ID="ddlPageCount" runat="server" Width="55px" CssClass="so" Visible="false"
                                                AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
                                                <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                                <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                                <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                                <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                        PageSize="20" AllowPaging="true" PagerStyle-Mode="NumericPages"
                                        CssClass="table2" GridLines="None" Width="100%"
                                        HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                        ItemStyle-CssClass="chan"
                                        OnItemDataBound="dgList_ItemDataBound" OnItemCommand="dgList_ItemCommand">
                                        <Columns>
                                            <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>Chọn</HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:HiddenField ID="hddVuAnID" runat="server" Value='<%#Eval("ID") %>' />
                                                    <asp:CheckBox ID="chkChoice" runat="server" AutoPostBack="true" />
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>Số & Ngày thụ lý</HeaderTemplate>
                                                <ItemTemplate>
                                                    <%#Eval("SOTHULYDON")%>
                                                    <br />
                                                    <%#Eval("NGAYTHULYDON")%>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>Thông tin bản án</HeaderTemplate>
                                                <ItemTemplate>
                                                    <%#Eval("SOANPHUCTHAM")%>
                                                    <br />
                                                    <%#Eval("NGAYXUPHUCTHAM")%>
                                                    <br />
                                                    <%#Eval("TOAXX_VietTat")%>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                             <asp:BoundColumn DataField="QHPNDN_Report" HeaderText="Quan hệ pháp luật" HeaderStyle-Width="60px"></asp:BoundColumn>
                                     <asp:TemplateColumn HeaderText="Nguyên đơn/ Người khởi kiện" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <%#(Eval("NGUYENDON")+"").Replace(",", ",<br/>")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                     <asp:TemplateColumn HeaderStyle-Width="70px" HeaderText="Bị đơn/ Người bị kiện" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <%#(Eval("BIDON")+"").Replace(",", ",<br/>")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                     <asp:TemplateColumn HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Người khiếu nại
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#(Eval("NGUOIKHIEUNAI")+"").Replace(",", ",<br/>")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>                                         
                                            <asp:TemplateColumn HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Justify" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    Thẩm tra viên<br />
                                                    Lãnh đạo Vụ<br />
                                                    Thẩm phán
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%#Eval("TENTHAMTRAVIEN")%> <i>(TTV)</i><br />
                                                    <%#Eval("TENLANHDAO")%> <i>(LĐV)</i><br />
                                                    <%#Eval("TENTHAMPHAN")%> <i>(TP)</i>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>Trạng thái</HeaderTemplate>
                                                <ItemTemplate>

                                                    <asp:Literal ID="lttLanTT" runat="server"></asp:Literal>
                                                    <br />
                                                    <asp:Literal ID="lttDetaiTinhTrang" runat="server"></asp:Literal>
                                                    <asp:Literal ID="lttKQGQ" runat="server"></asp:Literal>
                                                    <asp:Literal ID="lttOther" runat="server"></asp:Literal>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                        </Columns>
                                        <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                    </asp:DataGrid>
                                    <div class="phantrang">
                                        <div class="sobanghi">
                                            <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                        </div>
                                        <div class="sotrang">
                                            <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                                OnClick="lbTBack_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                            <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                            <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                            <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                                OnClick="lbTNext_Click"></asp:LinkButton>
                                            <asp:DropDownList ID="ddlPageCount2" runat="server" Width="55px" CssClass="so" Visible="false" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
                                                <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                                <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                                <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                                <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                <div class="processmodal">
                    <div class="processcenter">
                        <img src="/UI/img/process.gif" />
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
    </form>
    <script>
        function ReloadParent() {
            window.onunload = function (e) {
                opener.LoadDsDon();
            };
            window.close();
        }
        function ClosePopup() {
            var hddReloadParent = document.getElementById('<%=hddReloadParent.ClientID%>');
            if (hddReloadParent.value == "1")
                ReloadParent();
            window.close();
        }
    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = {
                '.chosen-select': {}
                , '.chosen-select-deselect': { allow_single_deselect: true }
                , '.chosen-select-no-single': { disable_search_threshold: 10 }
                , '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }
                , '.chosen-select-rtl': { rtl: true }
                , '.chosen-select-width': { width: '95%' }
            }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }

        function ChoiceVuAn(vuan_id) {
            var hddChoiceVuAn = document.getElementById('<%=hddChoiceVuAn.ClientID%>');
            if (vuan_id > 0) {
                var hdd_value = hddChoiceVuAn.value;
                if (hdd_value == vuan_id)
                    hddChoiceVuAn.value = "0";
                else
                    hddChoiceVuAn.value = vuan_id;
            }
            // alert('chọn:' + hddChoiceVuAn.value);
        }
        function validate() {
            var hddChoiceVuAn = document.getElementById('<%=hddChoiceVuAn.ClientID%>');
            var cmdSave = document.getElementById('<%=cmdSave.ClientID%>');
            if (vuan_id == 0) {
                alert('Bạn chưa chọn vụ án nào. Hãy kiểm tra lại!');
                cmdSave.focus();
                return false;
            }
            return true;
        }
        function validate_search() {
            var ddlToaXetXu = document.getElementById('<%=ddlToaXetXu.ClientID%>');
            var txtSoQDBA = document.getElementById('<%=txtSoQDBA.ClientID%>');
            var txtNgayBAQD = document.getElementById('<%=txtNgayBAQD.ClientID%>');

            var check_input = 0;
            value_change = ddlToaXetXu.options[ddlToaXetXu.selectedIndex].value;

            if (value_change != "0")
                check_input = check_input + 1;

            if (check_input == 0) {
                if (Common_CheckEmpty(txtSoQDBA.value))
                    check_input = check_input + 1;
            }

            if (check_input == 0) {
                if (Common_CheckEmpty(txtNgayBAQD.value))
                    check_input = check_input + 1;
            }

            if (check_input == 0) {
                alert("Bạn cần nhập ít nhất một mục thông tin để thực hiện việc tìm kiếm!");
                txtSoQDBA.focus();
                return false;
            }
            return true;
        }
    </script>

</body>

<script>

        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
        function BeginRequestHandler(sender, args) { var oControl = args.get_postBackElement(); oControl.disabled = true; }

</script>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
<script src="/UI/js/jquery.enhsplitter.js"></script>
</html>
