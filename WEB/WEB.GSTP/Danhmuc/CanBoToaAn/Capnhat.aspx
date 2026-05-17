<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Capnhat.aspx.cs" Inherits="WEB.GSTP.Danhmuc.CanBoToaAn.Capnhat" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style type="text/css">
        .lblEditDMCanBoCol1 {
            width: 120px;
        }

        .lblEditDMCanBoCol2 {
            width: 210px;
        }

        .lblEditDMCanBoCol3 {
            width: 73px;
        }

        .lblEditDMCanBoCol4 {
            width: 145px;
        }

        .lblEditDMCanBoCol5 {
            width: 115px;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <asp:HiddenField ID="hddCbID" runat="server" Value="0" />
                <table class="table1">
                    <tr>
                        <td>Tòa án</td>
                        <td colspan="5">
                            <asp:DropDownList CssClass="chosen-select" ID="DropToaAn" runat="server" Width="434px" AutoPostBack="True" OnSelectedIndexChanged="DropToaAn_SelectedIndexChanged"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td>Đơn vị trực thuộc</td>
                        <td colspan="5">
                            <asp:DropDownList CssClass="chosen-select" ID="ddlPhongban"  AutoPostBack="true" runat="server" OnSelectedIndexChanged="ddlPhongban_SelectedIndexChanged" Width="434px"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td align="left">Phòng ban
                        </td>
                        <td align="left" colspan="5">
                            <asp:DropDownList  CssClass="chosen-select" ID="ddlPhongban_sub" runat="server" Width="434px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>Mã cán bộ<asp:Label runat="server" ID="Label3" Text="(*)" ForeColor="Red"></asp:Label></td>
                        <td>
                            <asp:TextBox ID="txtMaCanBo" CssClass="user" runat="server" Width="192px" MaxLength="50"></asp:TextBox></td>
                        <td>Tên cán bộ<asp:Label runat="server" ID="Label1" Text="(*)" ForeColor="Red"></asp:Label></td>
                        <td colspan="3">
                            <asp:TextBox ID="txtHoten" CssClass="user" runat="server" Width="387px" MaxLength="250"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>Địa chỉ</td>
                        <td colspan="3">
                            <asp:TextBox ID="txtDiaChi" CssClass="user" runat="server" Width="427px" MaxLength="250"></asp:TextBox>
                        </td>
                        <td>Giới tính</td>
                        <td>
                            <asp:DropDownList CssClass="chosen-select" ID="ddlGioiTinh" runat="server" Width="117px">
                                <asp:ListItem Text="Nam" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Nữ" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="lblEditDMCanBoCol1">Số CMND</td>
                        <td class="lblEditDMCanBoCol2">
                            <asp:TextBox ID="txtCMND" CssClass="user" runat="server" Width="192px" MaxLength="50"></asp:TextBox></td>
                        <td class="lblEditDMCanBoCol3">Ngày sinh</td>
                        <td class="lblEditDMCanBoCol4">
                            <asp:TextBox ID="txtNgaySinh" runat="server" CssClass="user" Width="126px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server"
                                TargetControlID="txtNgaySinh" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server"
                                TargetControlID="txtNgaySinh" Mask="99/99/9999" MaskType="Date"
                                CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                        <td class="lblEditDMCanBoCol5">Số điện thoại</td>
                        <td>
                            <asp:TextBox ID="txtDienThoai" CssClass="user" runat="server" Width="110px" MaxLength="50"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Chức danh</td>
                        <td>
                            <asp:DropDownList CssClass="chosen-select" ID="DropChucDanh" runat="server" Width="200px"></asp:DropDownList></td>
                        <td>Chức vụ</td>
                        <td>
                            <asp:DropDownList CssClass="chosen-select" ID="DropChucVu" runat="server" Width="134px"></asp:DropDownList></td>
                        <td>Ngày nhận công tác</td>
                        <td>
                            <asp:TextBox ID="txtNgayNhanCT" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtNgayNhanCT_CalendarExtender" runat="server"
                                TargetControlID="txtNgayNhanCT" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server"
                                TargetControlID="txtNgayNhanCT" Mask="99/99/9999" MaskType="Date"
                                CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                    </tr>
                    <tr>
                        <td>Bổ nhiệm từ ngày<span class="batbuoc">(*)</span></td>
                        <td>
                            <asp:TextBox ID="txtBonhiemTungay" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server"
                                TargetControlID="txtBonhiemTungay" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server"
                                TargetControlID="txtBonhiemTungay" Mask="99/99/9999" MaskType="Date"
                                CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                        <td>Đến ngày<span class="batbuoc">(*)</span></td>
                        <td>
                            <asp:TextBox ID="txtBonhiemDenngay" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server"
                                TargetControlID="txtBonhiemDenngay" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server"
                                TargetControlID="txtBonhiemDenngay" Mask="99/99/9999" MaskType="Date"
                                CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                        <td>Ngày bắt đầu giải quyết đơn</td>
                        <td>
                            <asp:TextBox ID="txt_GQD_ThamPhan" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server"
                                TargetControlID="txt_GQD_ThamPhan" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server"
                                TargetControlID="txt_GQD_ThamPhan" Mask="99/99/9999" MaskType="Date"
                                CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                    </tr>
                    <tr>
                        <td>Lĩnh vực phụ trách</td>
                        <td colspan="5">
                            <table>
                                <tr>
                                    <td style="width: 120px;">
                                        <asp:CheckBox ID="chkHinhsu" runat="server" Text="Hình sự" /></td>
                                    <td style="width: 120px;">
                                        <asp:CheckBox ID="chkDansu" runat="server" Text="Dân sự" /></td>
                                    <td style="width: 150px;">
                                        <asp:CheckBox ID="chkHNGD" runat="server" Text="Hôn nhân & Gia đình" /></td>
                                    <td style="width: 150px;">
                                        <asp:CheckBox ID="chkKDTM" runat="server" Text="Kinh doanh thương mại" /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:CheckBox ID="chkLaodong" runat="server" Text="Lao động" /></td>
                                    <td>
                                        <asp:CheckBox ID="chkHanhchinh" runat="server" Text="Hành chính" /></td>
                                    <td>
                                        <asp:CheckBox ID="chkPhasan" runat="server" Text="Phá sản" /></td>
                                    <td>
                                        <asp:CheckBox ID="chkXLHC" runat="server" Text="Biện pháp XLHC" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td>Hội đồng</td>
                        <td colspan="5">
                            <asp:CheckBox ID="chkHoiDong" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>Tình trạng</td>
                        <td colspan="1">
                            <asp:DropDownList ID="ddlTinhtrang" runat="server" CssClass="chosen-select" Width="200px">
                                <asp:ListItem Text="Đang công tác" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Nghỉ phép" Value="2"></asp:ListItem>
                                <asp:ListItem Text="Nghỉ công tác" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td style="width:100px;">Tình trạng GQĐ/XX</td>
                        <td colspan="3">
                            <asp:DropDownList ID="ddlGQD" runat="server" CssClass="chosen-select" Width="200px">
                                <asp:ListItem Text="Đang GQĐGĐTTTT/XX ST,PT" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Dừng GQĐGĐTTTT/XX ST,PT" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6"></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="5">
                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="5">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnUpdate_Click" OnClientClick="return kiemtra()" />
                            <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="lblquaylai_Click" />
                            <asp:Button ID="btnBietPhai" runat="server" CssClass="buttoninput" Text="Thông tin biệt phái" OnClientClick="popupThongTinBietPhai()"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <div style="margin-top:10px;">
                                <b>Thông tin quá trình biệt phái</b>
                            </div>                             
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6">
                            <div>
                                <asp:HiddenField ID="hddBietPhaiID" runat="server" Value="0" />
                                <asp:Label runat="server" ID="lbThongbaoBP" ForeColor="Red"></asp:Label>
                            </div>
                            <asp:Panel runat="server" ID="pndata">
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="Id" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn ItemStyle-Width="40px" HeaderStyle-Width="40px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                STT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Container.ItemIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn> 
                                        <asp:TemplateColumn HeaderStyle-Width="150px" ItemStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tên cán bộ
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("HOTEN")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="200px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tòa án
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TOAAN") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="250px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Phòng ban
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("PHONGBAN") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="TUNGAY" HeaderText="Ngày bắt đầu" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"  ></asp:BoundColumn>
                                        <asp:BoundColumn DataField="DENNGAY" HeaderText="Ngày kết thúc" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"  ></asp:BoundColumn>   
                                        <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lbtSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") %>' OnClientClick=<%#"SuaThongTinBietPhai('" + Eval("ID") + "')" %>></asp:LinkButton>
                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function kiemtra() {
            var txtMa = document.getElementById('<%=txtMaCanBo.ClientID %>');
            if (txtMa.value.trim() == "" || txtMa.value.trim() == null) {
                alert('Bạn chưa nhập mã cán bộ!');
                txtMa.focus();
                return false;
            }
            else if (txtMa.value.trim().length > 50) {
                alert('Mã cán bộ không được quá 50 ký tự. Hãy nhập lại!');
                txtMa.focus();
                return false;
            }
            var txtHoten = document.getElementById('<%=txtHoten.ClientID %>');
            if (txtHoten.value.trim() == "" || txtHoten.value.trim() == null) {
                alert('Bạn chưa nhập tên cán bộ!');
                txtHoten.focus();
                return false;
            }
            else if (txtHoten.value.trim().length > 250) {
                alert('Tên cán bộ không được quá 250 ký tự. Hãy nhập lại!');
                txtHoten.focus();
                return false;
            }
            var txtDiaChi = document.getElementById('<%=txtDiaChi.ClientID %>');
            if (txtDiaChi.value.trim().length > 250) {
                alert('Địa chỉ không được quá 250 ký tự. Hãy nhập lại!');
                txtDiaChi.focus();
                return false;
            }
            var txtCMND = document.getElementById('<%=txtCMND.ClientID %>');
            if (txtCMND.value.trim().length > 50) {
                alert('Số CMND không được quá 50 ký tự. Hãy nhập lại!');
                txtCMND.focus();
                return false;
            }
            var txtNgaySinh = document.getElementById('<%=txtNgaySinh.ClientID%>');
            if (txtNgaySinh.value.trim().length > 0) {
                var arr = txtNgaySinh.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày sinh theo định dạng (dd/MM/yyyy).');
                    txtNgaySinh.focus();
                    return false;
                }
            }
            var txtDienThoai = document.getElementById('<%=txtDienThoai.ClientID %>');
            if (txtDienThoai.value.trim().length > 50) {
                alert('Điện thoại không được quá 50 ký tự. Hãy nhập lại!');
                txtDienThoai.focus();
                return false;
            }
            var txtNgayNhanCT = document.getElementById('<%=txtNgayNhanCT.ClientID%>');
            if (txtNgayNhanCT.value.trim().length > 0) {
                var arr = txtNgayNhanCT.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày nhận công tác theo định dạng (dd/MM/yyyy).');
                    txtNgayNhanCT.focus();
                    return false;
                }
            }
            return true;
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
    <script>
        function PopupCenter(pageURL, title, w, h) {
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            var targetWin = window.open(pageURL, title, 'toolbar=yes,scrollbars=yes,resizable=yes,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }
        function popupThongTinBietPhai() {
            var hddID = document.getElementById('<%=hddCbID.ClientID%>').value;
            var link = "/Danhmuc/CanBoToaAn/Popup/pThongTinBietPhai.aspx?cbID=" + hddID;
            PopupCenter(link, "Thông tin biệt phái", 1000, 200);
        }
        function SuaThongTinBietPhai(ID) {
            var link = "/Danhmuc/CanBoToaAn/Popup/pThongTinBietPhai.aspx?cbID=" + ID;
            PopupCenter(link, "Thông tin biệt phái", 1000, 200);
        }

    </script>
</asp:Content>
