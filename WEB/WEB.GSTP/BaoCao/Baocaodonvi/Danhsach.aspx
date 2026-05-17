<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.Baocao.Baocaodonvi.Danhsach" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <script src="../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="20" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <div class="boxchung">
                    <h4 class="tleboxchung bg_title_group">XEM BÁO CÁO ĐƠN VỊ</h4>
                    <div class="boder" style="padding: 5px 10px;">
                        <table class="table1" style="margin: 10px;">
                            <tr>
                                <td style="width: 80px;">Cấp tòa</td>
                                <td style="width: 190px;">
                                    <asp:DropDownList ID="Drop_Levels" CssClass="chosen-select" runat="server" Width="180px" CausesValidation="false"></asp:DropDownList>
                                </td>
                                <td style="width: 100px;">Tòa án</td>
                                <td style="width: 285px;">
                                    <asp:DropDownList ID="Drop_courts" CssClass="chosen-select" runat="server" Width="280px"
                                        skin="WebBlue" filter="Contains" DataTextField="COURT_NAME"
                                        DataValueField="ID" AutoPostBack="true" enableembeddedskins="true" allowcustomtext="true"
                                        markfirstmatch="true" >
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 95px;">
                                    <asp:Label ID="lbToaTrucThuoc" Text="Tòa cấp dưới" runat="server" Visible="false" /></td>
                                <td>
                                    <asp:DropDownList ID="Drop_courts_ext" CssClass="chosen-select" runat="server" Width="180px" Visible="false"
                                        skin="WebBlue" filter="Contains" DataTextField="COURT_NAME"
                                        DataValueField="ID" AutoPostBack="true" enableembeddedskins="true" allowcustomtext="true"
                                        markfirstmatch="true" CausesValidation="false" OnSelectedIndexChanged="ddl_courts_ext_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                                <td><asp:Label ID="lblGDT" Text="Loại GĐT/TT" runat="server" Visible="false"/></td>
                                <td>
                                    <asp:DropDownList ID="ddlGDT" CssClass="chosen-select" runat="server" Width="180px"  AutoPostBack="true" Visible ="false">
                                        <asp:ListItem Value="0" Text="Tất cả"  Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Giám đốc thẩm"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Tái thẩm"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                
                                <td>Loại Báo cáo</td>
                                <td>
                                    <asp:DropDownList ID="ddlGroupBaoCao" CssClass="chosen-select" runat="server" Width="180px" AutoPostBack="true" OnSelectedIndexChanged="ddlGroupBaoCao_SelectedIndexChanged">
                                        <asp:ListItem Value="1" Text="Báo cáo quản lý"  Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Báo cáo thống kê"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td>Mẫu báo cáo</td>
                                <td>
                                    <asp:DropDownList ID="ddlBaoCao" CssClass="chosen-select" runat="server" Width="280px" AutoPostBack="true" OnSelectedIndexChanged="ddlBaoCao_SelectedIndexChanged"></asp:DropDownList>
                                </td>
                                <td> <asp:Label ID="lblLoaiXuly" Text="Loại xử lý" runat="server" /></td>
                                <td  colspan ="3">
                                    <asp:DropDownList ID="ddlLoaiXuly" CssClass="chosen-select" runat="server" Width="180px" AutoPostBack="true">                                         
                                    </asp:DropDownList>
                                </td>
                                
                            </tr>
                            <tr>
                                <td>Từ ngày<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgay" runat="server" CssClass="user" Width="172px" MaxLength="10" ToolTip="Từ ngày"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgay" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td>Đến ngày<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="272px" MaxLength="10" ToolTip="Tới ngày" Enabled="true"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td><asp:Label ID="lblLoaian" Text="Loại án" runat="server" /></td>
                                <td  colspan ="3">
                                    <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select" runat="server" Width="180px">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td colspan="7">
                                    <div style="margin-top: 10px; color: red;">
                                        <asp:Literal ID="lstMsg" runat="server"></asp:Literal>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div style="margin: 5px; text-align: center; width: 95%">
                        <asp:Button ID="cmd_exels" runat="server" CssClass="buttoninput" Text="Xuất báo cáo" OnClientClick="return validate_thongtin();" OnClick="cmd_exels_Click" />
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
    <script type="text/html">
        function validate_thongtin() {
            var txtNgay = document.getElementById('<%=txtNgay.ClientID%>');
            if (!CheckDateTimeControl_KoSoSanhNgayHienTai(txtNgay, 'ngày bắt đầu báo cáo'))
                return false;
            var txtDenNgay = document.getElementById('<%=txtDenNgay.ClientID%>');
            if (!CheckDateTimeControl_KoSoSanhNgayHienTai(txtDenNgay, 'ngày kết thúc báo cáo'))
                return false;
            var partStartDate = txtNgay.value.split('/');
            var startDate = new Date(partStartDate[2], partStartDate[1] - 1, partStartDate[0]);
            var partEndDate = txtDenNgay.value.split('/');
            var endDate = new Date(partEndDate[2], partEndDate[1] - 1, partEndDate[0]);
            if (startDate.getTime() > endDate.getTime()) {
                alert('Ngày kết thúc báo cáo phải nhỏ hơn ngày bắt đầu báo cáo!');
                txtDenNgay.focus();
                return false;
            }
            return true;
        }
    </script>
    <script type="text/javascript">
        function showPopupReport(reportContent) {
            var strWindowFeatures = "menubar=no,location=no,resizable=no,scrollbars=yes,status=no";

            var newWindow = window.open("", "_blank", strWindowFeatures);
            newWindow.document.write(reportContent);
        }
    </script>

</asp:Content>
