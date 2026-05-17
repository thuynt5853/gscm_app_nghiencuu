<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pTraLaiDon.aspx.cs" Inherits="WEB.GSTP.QLAN.AHN.XuLyDon.Popup.pTraLaiDon" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Trả lại đơn</title>

    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/chosen.jquery.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:HiddenField ID="hddNgayNhanDon" Value="" runat="server" />
        <asp:HiddenField ID="hddFilePath" runat="server" />
        <asp:HiddenField ID="hddURLKS" runat="server" />
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div>
                    <style type="text/css">
                        body {
                            width: 98%;
                            margin-left: 1%;
                            min-width: 0px;
                            overflow: auto;
                        }

                        #UpdatePanel1 {
                            margin-left: 15px;
                        }

                        .check_list_vertical table td {
                            padding-right: 15px;
                        }

                        .boxchung {
                            padding-top: 10px;
                        }
                        .auto-style1 {
                            height: 36px;
                        }

                        .auto-style2 {
                            height: 36px;
                        }

                        .lable_td {
                            width: 117px;
                        }

                        .checkbox {
                            width: 100%;
                        }

                        .checkbox label {
                            margin-left: 5px;
                        }

                        .text_Right_css {
                            text-align: right;
                        }
                    </style>

                    <div class="boxchung">
                        <table class="table1">
                            <asp:Panel ID="pnBoSung" runat="server">
                                <tr>
                                    <td class="lable_td">
                                        <asp:Label ID="lblNgayBS" runat="server" Text="Ngày bổ sung"></asp:Label></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayBS" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayBS" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayBS" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                    <td class="lable_td">Số hiệu</td>
                                    <td style="width: 145px;">
                                        <asp:TextBox ID="txtSoHieu" runat="server" CssClass="user" Width="145px"></asp:TextBox>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <tr>
                                <td class="lable_td">Biện pháp GQ/YC</td>
                                <td style="width: 260px;">
                                    <asp:DropDownList ID="dropBienPhapGQ" CssClass="chosen-select user" runat="server"
                                        Width="250px" AutoPostBack="True" OnSelectedIndexChanged="dropBienPhapGQ_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                                <td class="lable_td">
                                    <asp:Label ID="lblNgayGQ" runat="server" Text="Ngày GQ/YC"></asp:Label><span class="must_input">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgayGQ" runat="server" CssClass="user" Width="145px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="txtNgayGQ_CalendarExtender" runat="server" TargetControlID="txtNgayGQ" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayGQ" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <!---------chọn = chuyen don trong nganh-------->
                            <asp:Panel ID="pnCDTN" runat="server" Visible="false">
                                <tr>
                                    <td>Tòa án nhận<span class="must_input">(*)</span></td>
                                    <td colspan="3">
                                        <asp:HiddenField ID="hddToaAn" runat="server" Value="0" />
                                        <a alt="Nhập tên để chọn tòa án" class="tooltipbottom">
                                            <asp:TextBox ID="txtToaAn" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                        </a>
                                    </td>

                                </tr>
                            </asp:Panel>
                            <!-----------------Chuyen don ngoai nganh-------------------------->
                            <asp:Panel ID="pnCDNN" runat="server" Visible="false">
                                <tr>
                                    <td>CQ/TC nhận đơn<span class="must_input">(*)</span></td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtCDNN_TenCoQuan" CssClass="user" runat="server" Width="242px" MaxLength="50"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td>Ngày chuyển</td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtCDNN_NgayChuyen" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="txtCDTN_NgayNhan_CalendarExten" runat="server" TargetControlID="txtCDNN_NgayChuyen" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtCDNN_NgayChuyen" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </tr>
                            </asp:Panel>
                            <!-----------------Tra don -------------------------->
                            <asp:Panel ID="pnTraDon" runat="server" Visible="false">
                                <tr>
                                    <td>Lý do<span class="must_input">(*)</span></td>
                                    <td>
                                        <asp:DropDownList ID="ddlLyTradon" runat="server" CssClass="chosen-select user" Width="250px"></asp:DropDownList>
                                    </td>
                                    <td class="lable_td">Ngày trả đơn</td>
                                    <td>
                                        <asp:TextBox ID="txtTradon_Ngay" runat="server" CssClass="user" Width="145px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtTradon_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtTradon_Ngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>

                                </tr>
                            </asp:Panel>
                            <!---------------------------------------------->
                            <asp:Panel ID="pnYCBS" runat="server" Visible="false">
                                <tr>
                                    <td>Thời hạn (ngày)</td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtThoihanBSYC" runat="server" CssClass="user text_Right_css" Width="242px" MaxLength="2" onkeypress="return isNumber(event)"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td>Yêu cầu bổ sung</td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtYCBS" CssClass="user" runat="server" Width="580px" TextMode="MultiLine" Rows="2"></asp:TextBox></td>
                                </tr>
                            </asp:Panel>
                            <tr>
                                <td>
                                    <asp:Label ID="lblLydo" runat="server" Text="Lý do"></asp:Label></td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtLyDo" CssClass="user" runat="server" Width="580px" TextMode="MultiLine" Rows="2"></asp:TextBox></td>
                            </tr>
                            <asp:Panel ID="pnThongbao" runat="server" Visible="false">
                                <tr>
                                    <td style="width: 128px;">Ngày thông báo<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgaythongbao" runat="server" CssClass="user" Width="242px" MaxLength="10"
                                            AutoPostBack="true" OnTextChanged="txtNgaythongbao_TextChanged1"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgaythongbao" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgaythongbao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                    <td class="lable_td">Số thông báo<span class="must_input">(*)</span></td>
                                    <td style="width: 242px;">
                                        <asp:TextBox ID="txtSothongbao" runat="server" CssClass="user" Width="105px"></asp:TextBox>
                                        <asp:DropDownList ID="ddlStbPhu" CssClass="chosen-select user" runat="server" Width="35px">
                                            <asp:ListItem Value="" Text="" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="A" Text="A"></asp:ListItem>
                                            <asp:ListItem Value="B" Text="B"></asp:ListItem>
                                            <asp:ListItem Value="C" Text="C"></asp:ListItem>
                                            <asp:ListItem Value="D" Text="D"></asp:ListItem>
                                            <asp:ListItem Value="E" Text="E"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <tr>
                                <td colspan="4">
                                    <div style="text-align: center; margin-top: 5px;">
                                        <asp:Button ID="cmdCapNhat" runat="server"
                                            CssClass="buttoninput" Text="Lưu" OnClick="cmdCapNhat_Click" OnClientClick=" return Validate();" />
                                        <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click"/>
                                        <input type="button" class="buttoninput" onclick="ReloadParent();" value="Đóng" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <asp:HiddenField ID="hddCurrID"  Value="0"  runat="server" />
                                    <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="boxchung">
                        <h4 class="tleboxchung">Lịch sử xử lý</h4>
                        <div class="boder" style="padding: 10px;">
                            <asp:DataGrid ID="dgDS" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="10" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" OnItemCommand="dgDS_ItemCommand" OnItemDataBound="dgDS_ItemDataBound">
                                <Columns>

                                    <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            TT
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Container.DataSetIndex + 1 %>                                           
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="BIENPHAPGQ" HeaderText="Biện pháp GQ" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="160px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGUOIGQ" HeaderText="Người GQ" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="120px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGAYGQ_YC" HeaderText="Ngày GQ/YC" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="60px" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="180px" HeaderStyle-HorizontalAlign="Center">
                                                                <HeaderTemplate>
                                                                    Người tạo
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    - Người tạo: <%# Eval("NguoiTao") %>
                                                                    <br />
                                                                    - Ngày tạo: <%# string.Format("{0:dd/MM/yyyy}",Eval("NgayTao")) %>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thao tác</HeaderTemplate>
                                        <ItemTemplate>
                                            <div class="tooltip">
                                                <asp:ImageButton ID="cmdEdit" runat="server" ToolTip="Sửa" CssClass="grid_button"
                                                    CommandName="Sua" CommandArgument='<%#Eval("ID") %>'
                                                    ImageUrl="~/UI/img/edit_doc.png" Width="18px" />
                                                <span class="tooltiptext  tooltip-bottom">Sửa</span>
                                            </div>
                                            <div class="tooltip">
                                                <asp:ImageButton ID="cmdXoa" runat="server" ToolTip="Xóa" CssClass="grid_button"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                    ImageUrl="~/UI/img/delete.png" Width="17px"
                                                    OnClientClick="return confirm('Bạn thực sự muốn xóa? ');" />
                                                <span class="tooltiptext  tooltip-bottom">Xóa</span>
                                            </div>
                                            <div class="tooltip">
                                                <asp:ImageButton ID="cmdView" runat="server" ToolTip="Chi tiết" CssClass="grid_button"
                                                    CommandName="ChiTiet" CommandArgument='<%#Eval("ID") %>'
                                                    ImageUrl="~/UI/img/edit_doc.png" Width="18px" />
                                                <span class="tooltiptext  tooltip-bottom">Chi tiết</span>
                                            </div>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>                       
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                        </div>
                    </div>
                </div>
                <script>
                    function ReloadParent() {
                        OnClose();
                    }
                </script>
                <script type="text/javascript">
                    function Validate() {
                        var txtNgayGQ = document.getElementById('<%= txtNgayGQ.ClientID%>');
                        if (!CheckDateTimeControl(txtNgayGQ, "ngày GQ/YC"))
                            return false;
                        var NgayGQ = txtNgayGQ.value;
                        var hddNgayNhanDon = document.getElementById('<%=hddNgayNhanDon.ClientID%>');
                        var NgayNhanDon;
                        if (hddNgayNhanDon.value != "") {
                            arr = hddNgayNhanDon.value.split('/');
                            NgayNhanDon = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                            if (NgayGQ < NgayNhanDon) {
                                alert('Ngày GQ/YC không được nhỏ hơn ngày nhận đơn ' + hddNgayNhanDon.value + '.');
                                txtNgayGQ.focus();
                                return false;
                            }
                        }
                        //-----------------------------
                        var dropBienPhapGQ = document.getElementById('<%=dropBienPhapGQ.ClientID%>');
                        var bienphap = dropBienPhapGQ.options[dropBienPhapGQ.selectedIndex].value;
                        var CDTrongNganh = 1, CDNgoaiNganh = 2, TraLaiDon = 3, YCBoSung = 4, ThuLy = 5;
                        if (bienphap == CDTrongNganh) {
                            var hddToaAn = document.getElementById('<%= hddToaAn.ClientID %>');
                            var txtToaAn = document.getElementById('<%= txtToaAn.ClientID %>');
                            if (hddToaAn.value == '' || hddToaAn.value == "0") {
                                alert('Bạn cần chọn tòa án nhận.');
                                txtToaAn.focus();
                                return false;
                            }
                        }
                        else if (bienphap == TraLaiDon) {
                            var txtTradon_Ngay = document.getElementById('<%=txtTradon_Ngay.ClientID%>');
                            if (Common_CheckEmpty(txtTradon_Ngay.value)) {
                                if (!Common_IsTrueDate(txtTradon_Ngay.Value))
                                    return false;
                                if (!Sosanh2Date(txtTradon_Ngay, "Ngày trả đơn", NgayGQ, "Ngày GQ/YC"))
                                    return false;
                            }
                        }
                        else if (bienphap == YCBoSung) {
                            var txtYCBS = document.getElementById('<%=txtYCBS.ClientID%>');
                            if (Common_CheckEmpty(txtYCBS.value)) {
                                if (txtYCBS.value.length > 1000) {
                                    alert('Yêu cầu bổ sung không quá 1000 ký tự.');
                                    txtYCBS.focus();
                                    return false;
                                }
                            }
                        }
                        var txtSothongbao = document.getElementById('<%= txtSothongbao.ClientID %>');
                        if (!Common_CheckTextBox(txtSothongbao, "Số thông báo")) {
                            return false;
                        }
                        var txtLyDo = document.getElementById('<%= txtLyDo.ClientID %>');
                        if (txtLyDo.value.length > 500) {
                            var msg = '';
                            if (bienphap == TraLaiDon)
                                msg = 'Ghi chú không quá 500 ký tự';
                            else
                                msg = 'Lý do không quá 500 ký tự';
                            alert(msg);
                            txtLyDo.focus();
                            return false;
                        }
                        return true;
                    }
                    function isNumber(evt) {
                        evt = (evt) ? evt : window.event;
                        var charCode = (evt.which) ? evt.which : evt.keyCode;
                        if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                            return false;
                        }
                        return true;
                    }
                    function OnClose() {
                        if (window.opener != null && !window.opener.closed) {
                            window.opener.HideModalDiv();
                        }
                        window.close();
                    }
                    window.onunload = OnClose;
                </script>
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
</body>
</html>
