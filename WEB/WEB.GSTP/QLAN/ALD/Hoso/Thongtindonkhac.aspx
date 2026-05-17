<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Thongtindonkhac.aspx.cs" Inherits="WEB.GSTP.QLAN.ALD.Hoso.Thongtindonkhac" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/QLAN/DONGHEP/DONKHAC/DonGhep.ascx" TagPrefix="uc3" TagName="DONGHEPDONKHAC" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddID" runat="server" Value="0" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <%--<div style="margin: 5px; text-align: center; width: 95%">
                    <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdUpdate_Click" />
                    <asp:Button ID="cmdUpdateSelect" runat="server" CssClass="buttoninput" Text="Lưu & Chọn xử lý" OnClick="cmdUpdateSelect_Click" />
                    <asp:Button ID="cmdUpdateAndNew" runat="server" CssClass="buttoninput" Text="Lưu & Thêm mới" OnClick="cmdUpdateAndNew_Click" />
                    <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdQuaylai_Click" />
                </div>--%>
                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                    <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
                </div>
                <div class="boxchung">
                    <h4 class="tleboxchung">Thông tin vụ việc</h4>
                    <div class="boder" style="padding: 10px;">
                        <asp:Panel ID="TTVV" runat="server" Enabled="false">
                        <table class="table1">
                               <tr style="display:none;">
                                <td style="width: 115px;">Mã vụ việc</td>
                                <td style="width: 250px;">
                                    <asp:TextBox ID="txtMaVuViec" CssClass="user"
                                        placeholder="Mã vụ việc tự sinh" ReadOnly="true"
                                        runat="server" Width="98%" MaxLength="50" Enabled="false"></asp:TextBox></td>
                                <td style="width: 145px;">Tên vụ việc</td>
                                <td>
                                    <asp:TextBox ID="txtTenVuViec" CssClass="user" placeholder="Tên vụ việc tự sinh"
                                        ReadOnly="true" runat="server" Width="98%" TextMode="MultiLine" Rows="2" Height="40px" Enabled="false"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td style="width: 115px;">Hình thức nhận đơn</td>
                              <td style="width: 260px;">
                                    <asp:DropDownList ID="ddlHinhthucnhandon" CssClass="chosen-select"
                                        runat="server" Width="250px">
                                        <asp:ListItem Value="1" Text="Trực tiếp"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Qua bưu điện"></asp:ListItem>
                                        <asp:ListItem Value="3" Text="Trực tuyến"></asp:ListItem>
                                    </asp:DropDownList></td>
                               <td style="width: 145px;">Loại đơn</td>
                                <td>
                                    <asp:DropDownList ID="ddlLoaidon" CssClass="chosen-select" runat="server" Width="250px">
                                        <asp:ListItem Value="1" Text="Đơn khởi kiện"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Đơn từ Tòa án khác chuyển đến"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>Ngày ghi trên đơn</td>
                                <td>
                                    <asp:TextBox ID="txtNgayViet" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtNgayViet" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayViet" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayViet" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                </td>
                                <td>Ngày nhận đơn hoặc ngày ghi trên dấu bưu điện <span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgayNhan" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayNhan" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayNhan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayNhan" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>Quan hệ pháp luật <span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlLoaiQuanhe" CssClass="chosen-select" 
                                      Visible="false"   runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlLoaiQuanhe_SelectedIndexChanged">
                                        <asp:ListItem Value="1" Text="Tranh chấp"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Yêu cầu"></asp:ListItem>
                                    </asp:DropDownList>                              
                                    <asp:DropDownList ID="ddlQuanhephapluat" Visible="false" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlQuanhephapluat_SelectedIndexChanged"></asp:DropDownList>
                                    <asp:TextBox ID="txtQuanhephapluat" CssClass="user" placeholder="" runat="server" Width="240px" MaxLength="500" TextMode="MultiLine" Enabled="false"></asp:TextBox>

                                </td>
                                  <td>QHPL dùng cho thống kê<span class="batbuoc">(*)</span></td>
                                <td>
                                     <asp:DropDownList ID="ddlQHPLTK" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                    </td>
                            </tr>
                            <tr>
                                <td>Cán bộ nhận đơn<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlCanbonhandon" CssClass="chosen-select" runat="server" Width="250px">
                                    </asp:DropDownList>
                                </td>
                                <td>Thẩm phán ký nhận đơn</td>
                                <td>
                                    <asp:DropDownList ID="ddlThamphankynhandon" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList></td>
                            </tr>
                              <tr style="display:none;">
                                <td>Yếu tố nước ngoài<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlYeutonuocngoai" Enabled="false" CssClass="chosen-select" runat="server" Width="98%">
                                        <asp:ListItem Value="3" Text="Chưa xác định"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Không"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td>Đơn kiện của người khác</td>
                                <td>
                                    <asp:TextBox ID="txtDonkiencuanguoikhac" CssClass="user" runat="server" Width="98%"></asp:TextBox></td>
                            </tr>                         
                            <tr>
                                <td>Nội dung khởi kiện</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtNoidungkhoikien" CssClass="user" runat="server" Width="653px" TextMode="MultiLine"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                            </asp:Panel>
                    </div>
                </div>
                <div style="margin: 5px; width: 99%;">
                    <uc3:DONGHEPDONKHAC runat="server" ID="DONGHEPDONKHAC" />
                </div>
                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                    <asp:Literal ID="lstMsgB" runat="server"></asp:Literal>
                </div>
                <%--<div style="margin: 5px; text-align: center; width: 95%">
                    <asp:Button ID="cmdUpdateB" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdUpdate_Click" />
                    <asp:Button ID="cmdUpdateSelectB" runat="server" CssClass="buttoninput" Text="Lưu & Chọn xử lý"
                        OnClick="cmdUpdateSelect_Click" />
                    <asp:Button ID="cmdUpdateAndNewB" runat="server" CssClass="buttoninput" Text="Lưu & Thêm mới"
                        OnClick="cmdUpdateAndNew_Click" />
                    <asp:Button ID="cmdQuaylaiB" runat="server" CssClass="buttoninput" Text="Quay lại"
                        OnClick="cmdQuaylai_Click" />
                </div>--%>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function Setfocus(controlid) {
            var ctrl = document.getElementById(controlid);
            ctrl.focus();
        }
    </script>
</asp:Content>
