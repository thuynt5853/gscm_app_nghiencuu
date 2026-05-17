<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.GSTP.Danhsach" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../UI/js/Common.js"></script>

    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="20" runat="server" />
    <style type="text/css">
        .table2 td a {
            text-decoration: none;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Tìm kiếm</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td><b>Đơn vị</b></td>
                            <td colspan="3">
                                <asp:DropDownList ID="ddlDonVi" CssClass="chosen-select" runat="server" Width="528px"></asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 111px;"><b>Tên thẩm phán</b></td>
                            <td style="width: 288px;">
                                <asp:TextBox ID="txtTen" CssClass="user" runat="server" Width="270px" MaxLength="50" onkeypress="return KeypressUp_Enter(event);"></asp:TextBox></td>
                            <td style="width: 75px;"><b>Ngày sinh</b></td>
                            <td>
                                <asp:TextBox ID="txtNgaySinh" runat="server" CssClass="user" Width="143px" MaxLength="10" onkeypress="return KeypressUp_Enter(event);"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtNgaySinh" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgaySinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Vai trò trong vụ án</b></td>
                            <td>
                                <asp:DropDownList ID="ddlvaiTro" CssClass="chosen-select" runat="server" Width="277px">
                                    <asp:ListItem Value="" Text="Tất cả"></asp:ListItem>
                                    <asp:ListItem Value="THAMPHAN" Text="Thẩm phán chủ tọa phiên tòa"></asp:ListItem>
                                    <asp:ListItem Value="THAMPHANHDXX" Text="Thẩm phán thành viên hội đồng xét xử"></asp:ListItem>
                                    <asp:ListItem Value="THAMPHANDUKHUYET" Text="Thẩm phán dự khuyết"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td><b>Chức danh</b></td>
                            <td>
                                <asp:DropDownList ID="ddlChucDanh" CssClass="chosen-select" runat="server" Width="151px"></asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Ngày phân công từ</b></td>
                            <td>
                                <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="270px" MaxLength="10" onkeypress="return KeypressUp_Enter(event);"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <td><b>Đến ngày</b></td>
                            <td>
                                <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="143px" MaxLength="10" onkeypress="return KeypressUp_Enter(event);"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4">
                                <asp:CheckBoxList ID="chkListTrangThai" runat="server" RepeatDirection="Horizontal" RepeatColumns="5">
                                    <asp:ListItem Value="0" Text="Sắp hết nhiệm kỳ"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Có khiếu nại, tố cáo"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Bị kỷ luật"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="Vụ án bị hủy"></asp:ListItem>
                                    <asp:ListItem Value="4" Text="Vụ án có áp dụng các biện pháp khẩn cấp tạm thời"></asp:ListItem>
                                    <asp:ListItem Value="5" Text="Vụ án đình chỉ"></asp:ListItem>
                                    <asp:ListItem Value="6" Text="Vụ án tạm đình chỉ"></asp:ListItem>
                                    <asp:ListItem Value="7" Text="Vụ án quá hạn"></asp:ListItem>
                                    <asp:ListItem Value="8" Text="Vụ án bị sửa"></asp:ListItem>
                                    <asp:ListItem Value="9" Text="Vụ án áp dụng án treo"></asp:ListItem>
                                </asp:CheckBoxList>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td colspan="3">
                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="cmdTimkiem_Click" OnClientClick="return validate();" />
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td colspan="3">
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label></td>
                        </tr>
                    </table>

                </div>
            </div>
            <div class="truong" id="DSThamPhan" runat="server" visible="false">
                <table class="table1">
                    <tr>
                        <td>
                            <span style="font-weight: bold; text-transform: uppercase;">Danh sách các thẩm phán</span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                </div>
                            </div>
                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" AlternatingItemStyle-CssClass="le" ShowHeader="true"
                                ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgList_ItemCommand">
                                <Columns>
                                    <asp:TemplateColumn HeaderStyle-Width="40px" HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>STT</HeaderTemplate>
                                        <ItemTemplate><%#Eval("STT") %></ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="HoTen" HeaderText="Họ và tên" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="200px" HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="TenDonVi" HeaderText="Đơn vị" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NgaySinh" HeaderText="Ngày sinh" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="70px" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="ChucDanh" HeaderText="Chức danh" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td" HeaderStyle-Width="150px"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="121px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Đánh giá</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbtDanhGia" runat="server" ForeColor="#0e7eee" CausesValidation="false" Text="Thông tin Thẩm phán" CommandName="DanhGia" CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
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
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>

        </div>
    </div>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
    <script type="text/javascript">
        function KeypressUp_Enter(event) {
            if (event.which === 13 || event.keyCode === 13 || event.key === "Enter") {
                event.preventDefault();
                document.getElementById('<%=cmdTimkiem.ClientID%>').click();
            }
        }
        function validate() {
            var txtTuNgay = document.getElementById('<%=txtTuNgay.ClientID%>');
            var txtDenNgay = document.getElementById('<%=txtDenNgay.ClientID%>');
            var lenghtTuNgay = txtTuNgay.value.trim().length;
            var TuNgay;
            if (lenghtTuNgay > 0) {
                var arrTuNgay = txtTuNgay.value.split('/');
                TuNgay = new Date(arrTuNgay[2] + '-' + arrTuNgay[1] + '-' + arrTuNgay[0]);
                if (TuNgay.toString() == "NaN" || TuNgay.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày phân công từ ngày theo định dạng (dd/MM/yyyy)!');
                    txtTuNgay.focus();
                    return false;
                }
            }
            var lenghtDenNgay = txtDenNgay.value.trim().length;
            var DenNgay;
            if (lenghtDenNgay > 0) {
                var arrDenNgay = txtDenNgay.value.split('/');
                DenNgay = new Date(arrDenNgay[2] + '-' + arrDenNgay[1] + '-' + arrDenNgay[0]);
                if (DenNgay.toString() == "NaN" || DenNgay.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày phân công đến ngày theo định dạng (dd/MM/yyyy)!');
                    txtDenNgay.focus();
                    return false;
                }
            }
            if (lenghtTuNgay > 0 && lenghtDenNgay > 0 && TuNgay > DenNgay) {
                alert('Ngày phân công từ ngày phải nhỏ hơn hoặc bằng đến ngày.');
                txtDenNgay.focus();
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
