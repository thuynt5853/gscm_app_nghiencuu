<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pMienAnPhi.aspx.cs" Inherits="WEB.GSTP.QLAN.APS.XuLyDon.Popup.pMienAnPhi" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lịch sử miễn án phí</title>

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
        <asp:HiddenField ID="hddURLKS" runat="server" />
        <asp:HiddenField ID="hddFileid" Value="0" runat="server" />
        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <asp:HiddenField ID="hddTotalPageAP" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndexAP" Value="1" runat="server" />
        <asp:HiddenField ID="HiddenField1" Value="" runat="server" />
        <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
        <asp:HiddenField ID="hddShowCommandAP" runat="server" Value="True" />
        <asp:HiddenField ID="hddNgayNhanDon" Value="" runat="server" />
        <asp:HiddenField ID="hddFilePath" runat="server" />
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
                           <tr>
                                <td style="width: 150px">Miễn án phí?</td>
                                <td>
                                    <asp:CheckBox ID="chkNopAnPhi" runat="server" Text=""
                                        AutoPostBack="True" Checked="true" Enabled="false"/>

                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblLydo" runat="server" Text="Lý do"></asp:Label></td>
                                <td colspan ="3">
                                    <asp:TextBox ID="txtLyDo" CssClass="user" runat="server" Width="615px" TextMode="MultiLine" Rows="2"></asp:TextBox></td>
                            </tr>
                            <%--<asp:Panel ID="pnThongbao" runat="server" Visible="true">--%>
                                <tr>
                                    <td>Ngày thông báo<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgaythongbaoAP" runat="server" CssClass="user" Width="146px" MaxLength="10"
                                            AutoPostBack="true" OnTextChanged="txtNgaythongbaoAP_TextChanged" Height="20px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgaythongbaoAP" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgaythongbaoAP" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                    <td class="lable_td">Số thông báo<span class="must_input">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtSothongbaoAP" runat="server" CssClass="user" Width="90px"></asp:TextBox>
                                        <asp:DropDownList ID="ddlStbPhuAP" CssClass="user" runat="server" Width="54px">
                                            <asp:ListItem Value="" Text="" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="A" Text="A"></asp:ListItem>
                                            <asp:ListItem Value="B" Text="B"></asp:ListItem>
                                            <asp:ListItem Value="C" Text="C"></asp:ListItem>
                                            <asp:ListItem Value="D" Text="D"></asp:ListItem>
                                            <asp:ListItem Value="E" Text="E"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            <%--</asp:Panel>--%>
                            <tr>
                                <td colspan="4">
                                    <div style="text-align: center; margin-top: 5px;">
                                        <asp:Button ID="cmdCapNhatAP" runat="server"
                                            CssClass="buttoninput" Text="Lưu" OnClick="cmdCapNhatAP_Click" />
                                        <input type="button" class="buttoninput" onclick="ReloadParent();" value="Đóng" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:Label runat="server" ID="lbThongbaoAP" ForeColor="Red" Style="margin-left: 15px;"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <asp:HiddenField ID="hddCurrAPID" runat="server" />
                    <asp:HiddenField ID="hddHistoryId" runat="server" />
                    <div class="boxchung">
                        <h4 class="tleboxchung">Lịch sử thông báo án phí</h4>
                        <div class="boder" style="padding: 10px;">
                            <asp:DataGrid ID="rptAP" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%"
                                OnItemCommand="rptAP_ItemCommand" OnItemDataBound="rptAP_ItemDataBound">
                                <Columns>
                                    <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            TT
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Container.DataSetIndex + 1 %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Nguyên đơn/ Người KK
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("DUONGSU") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Right">
                                        <HeaderTemplate>
                                            Tạm ứng AP
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("TAMUNGAP") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Ngày nộp tạm ứng án phí
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                           <%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYNOPANPHI")) %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Người nộp
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("NGUOINOP") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="center">
                                        <HeaderTemplate>
                                            Số biên lai
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("SOBIENLAI") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="175px">
                                        <HeaderTemplate>Biên lai đính kèm</HeaderTemplate>
                                        <ItemTemplate>
                                            <div>
                                                <i>Mã thông báo:</i>
                                                <b><%#Eval("MA_THONGBAO") %></b>
                                            </div>
                                            <div style="margin-top: 5px;">
                                                <asp:ImageButton ID="lblDownloadAP" ImageUrl="/UI/img/Manager/file_attach_pdf.gif" runat="server" CausesValidation="false" CommandName="DownloadAP"
                                                    CommandArgument='<%#Eval("FILEID") %>' ToolTip='<%#Eval("TENFILE")%>' />
                                                <asp:HiddenField ID="hd_DownloadAP" runat="server" Value='<%#Eval("MA_THONGBAO").ToString()+";"+Eval("DVCQG_TT_ID") %>' />
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Người tạo
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("NguoiTao") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Ngày tạo
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%# string.Format("{0:dd/MM/yyyy}",Eval("NgayTao")) %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="105px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Thao tác
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                           <asp:ImageButton ID="lblSuaAP" runat="server" Text="Sửa" CausesValidation="false" CommandName="SuaAP" ForeColor="#0e7eee"
                                                CommandArgument='<%#Eval("mienanphiId") %>' ImageUrl="~/UI/img/edit_doc.png" Width="18px" ></asp:ImageButton>
                                           &nbsp;&nbsp;<asp:ImageButton ID="lbtXoaAP" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee" CommandName="XoaAP"
                                                ImageUrl="~/UI/img/delete.png" Width="17px"
                                                CommandArgument='<%#Eval("mienanphiId") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:ImageButton>
                                            <br />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                </Columns>
                                <HeaderStyle CssClass="header"></HeaderStyle>
                                <ItemStyle CssClass="chan"></ItemStyle>
                                <PagerStyle Visible="false"></PagerStyle>
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
                    <%--function Validate() {
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
                    }--%>
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
                            window.opener.HideModalDivAP();
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

