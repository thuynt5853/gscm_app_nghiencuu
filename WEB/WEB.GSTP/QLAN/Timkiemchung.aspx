<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Timkiemchung.aspx.cs" Inherits="WEB.GSTP.QLAN.Timkiemchung" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Tìm kiếm</h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        <tr>
                                            <td>
                                                <div style="float: left; width: 1050px">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Loại án</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select" runat="server" Width="248px">
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div style="float: left; width: 1050px; margin-top: 8px;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tên vụ án</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtTenVuViec" CssClass="user" runat="server" Width="240px"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tội danh/ QHPL</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txt_toidanh" CssClass="user" runat="server" Width="238px"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Mã vụ án</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtMaVuViec" CssClass="user" runat="server" Width="242px" MaxLength="50"></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div style="float: left; width: 1050px; margin-top: 8px;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Bị can /Bị cáo/ Đương sự</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtBiCan" CssClass="user" runat="server" Width="240px" MaxLength="50"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Cấp xét xử</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="dropCapxx" CssClass="chosen-select" runat="server" Width="246px"
                                                            AutoPostBack="True" OnSelectedIndexChanged="dropCapxx_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tòa xx sơ thẩm</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="DropToaAn" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="DropToaAn_SelectedIndexChanged"></asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div style="float: left; width: 1050px; margin-top: 4px;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tình trạng thụ lý</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="DropTINHTRANG_THULY" CssClass="chosen-select" runat="server" Width="248px">
                                                            <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                            <asp:ListItem Value="1" Text="Đã thụ lý" Selected="True"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="Chưa thụ lý"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 85px; text-align: right; margin-right: 10px;">

                                                        <asp:DropDownList ID="ddlSoSTL_TB" Width="60px" runat="server" Enabled="false">
                                                            <asp:ListItem Value="1" Text="Số TL" Selected="True"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="Số TB"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtSOTHULY_THONGBAO" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Từ ngày</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txt_NGAYTHULY_TU" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txt_NGAYTHULY_TU" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txt_NGAYTHULY_TU" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txt_NGAYTHULY_TU" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                    <div style="float: left; width: 65px; text-align: right; margin-right: 10px;">Đến ngày</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txt_NGAYTHULY_DEN" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txt_NGAYTHULY_DEN" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txt_NGAYTHULY_DEN" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txt_NGAYTHULY_DEN" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                </div>
                                                <div style="float: left; width: 1050px; margin-top: 2px;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tình trạng GQ</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="DropTINHTRANG_GIAIQUYET" CssClass="chosen-select" runat="server" Width="248px"
                                                            AutoPostBack="True" OnSelectedIndexChanged="DropTINHTRANG_GIAIQUYET_SelectedIndexChanged">
                                                            <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                            <asp:ListItem Value="1" Text="+ Chưa giải quyết xong"></asp:ListItem>
                                                            <asp:ListItem Value="11" Text=".....Hồ sơ chưa chuyển VKS"></asp:ListItem>
                                                            <asp:ListItem Value="12" Text=".....Hồ sơ Đã chuyển VKS"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text=".....Chưa phân công Thẩm phán"></asp:ListItem>
                                                            <asp:ListItem Value="3" Text=".....Đã phân công Thẩm phán"></asp:ListItem>
                                                            <asp:ListItem Value="4" Text=".....Đã lên lịch xét xử"></asp:ListItem>
                                                            <asp:ListItem Value="5" Text=".....Đang hoãn"></asp:ListItem>
                                                            <asp:ListItem Value="6" Text=".....Đang tạm đình chỉ"></asp:ListItem>
                                                            <asp:ListItem Value="7" Text="+ Đã giải quyết xong"></asp:ListItem>
                                                            <asp:ListItem Value="8" Text=".....Đã xét xử"></asp:ListItem>
                                                            <asp:ListItem Value="9" Text=".....Đình chỉ"></asp:ListItem>
                                                            <asp:ListItem Value="10" Text=".....Chuyển vụ án"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Từ ngày </div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="txtTuNgay_CalendarExtender" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                    <div style="float: left; width: 75px; text-align: center;">Đến ngày</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtDenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                    <div style="float: left; width: 65px; text-align: right; margin-right: 10px;">Thẩm phán</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlThamphan" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                        <asp:HiddenField ID="hddLoaiTK" runat="server" Value="" />
                                                    </div>
                                                </div>
                                                <div style="float: left; width: 1050px; margin-top: 6px;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Kết quả xx PT</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="Drop_KETQUA" CssClass="chosen-select" runat="server" Width="248px">
                                                            <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                            <asp:ListItem Value="1" Text="...Giữ nguyên quyết định/bản án sơ thẩm"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="...Tăng hình phạt "></asp:ListItem>
                                                            <asp:ListItem Value="3" Text="...Giảm hình phạt"></asp:ListItem>
                                                            <asp:ListItem Value="4" Text="...Hủy quyết định/bản án sơ thẩm để.."></asp:ListItem>
                                                            <asp:ListItem Value="5" Text="...Sửa phần dân sự"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Số BA/QĐ </div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtSoQD" CssClass="user" runat="server" Width="70px"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Ngày BA/QĐ</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txt_NgayQD" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txt_NgayQD" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txt_NgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator5" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txt_NgayQD" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                    <div style="float: left; width: 65px; text-align: right; margin-right: 10px;">Vai trò của Thẩm phán</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlVaiTroThamPhan" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div style="float: left; width: 1050px; margin-top: 8px;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Thời hạn GQ</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="DropTHOIHAN_GQ" CssClass="chosen-select" runat="server" Width="248px">
                                                            <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                            <asp:ListItem Value="1" Text="...Đã hết thời hạn"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="...Còn thời hạn dưới 10 ngày"></asp:ListItem>
                                                            <asp:ListItem Value="3" Text="...Còn thời hạn dưới 20 ngày"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">QĐ tạm giam</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="DropQD_TAMGIAM" CssClass="chosen-select" runat="server" Width="246px">
                                                            <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                            <asp:ListItem Value="1" Text="...Đã hết thời hạn"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="...Còn thời hạn dưới 10 ngày"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Thư ký</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlHTND_Thuky" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div style="float: left; width: 1050px; margin-top: 6px;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Ủy thác tư pháp</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="dropUTTP" CssClass="chosen-select" runat="server" Width="250px">
                                                            <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                            <asp:ListItem Value="0" Text="...Không có ủy thác đi"></asp:ListItem>
                                                            <asp:ListItem Value="1" Text="...Có ủy thác đi"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <%--VPNT- Đinh Hoàng Sơn - thêm điều kiện lọc Vụ án đã giải quyết xong từ toà cũ -19-9-2025--%>
                                                <div style="float: right; width: 1050px; margin-top: 8px;"> 
                                                    <div style="float: right; margin-left: -25px; width: 50px; text-align: right; margin-right: 200px;">
                                                        <asp:CheckBox ID="ck_ANKETTHUC" runat="server" AutoPostBack="true" OnCheckedChanged="ck_ANKETTHUC_CheckedChanged" />
                                                    </div>

                                                    <div style="float: right; text-align: right; margin-right: 10px; margin-top: 2px;">Vụ án đã giải quyết xong từ toà cũ</div>

                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td style="width: 150px;" align="left"></td>
                        <td align="left">
                            <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="cmdTimkiem_Click" />
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                            <div style="display: none;">
                                <asp:Button ID="cmdThemmoi" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="btnThemmoi_Click" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">In danh sách, biểu mẫu
                                </h4>
                                <div class="boder" style="padding: 10px;">
                                    <table style="width: 100%">
                                        <tr>
                                            <td>

                                                <div style="float: left; width: 1050px; margin-top: 8px;">
                                                    <div style="float: right; margin-left: 9px; margin-right: 32px;">
                                                        <asp:Button ID="btn_baocao" OnClick="btn_baocao_Click" runat="server" Width="100px" CssClass="buttonprint" Text="Báo cáo" />
                                                    </div>
                                                    <div style="float: right;">
                                                        <asp:DropDownList ID="Drop_bieu_mau" CssClass="chosen-select" runat="server" Width="300px">
                                                            <asp:ListItem Value="1" Text="Danh sách chung"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="Danh sách án thụ lý"></asp:ListItem>
                                                            <asp:ListItem Value="3" Text="Danh sách án chưa chuyển HS sang VKS"></asp:ListItem>
                                                            <asp:ListItem Value="4" Text="Danh sách án đã chuyển HS sang VKS"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: right; margin-right: 50px;">
                                                        <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red" Font-Size="17px"></asp:Label>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="left">
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Button ID="cmdGiaoVKS" Visible="false" ToolTip="Chỉ cho phép giao các hồ sơ chưa chuyển VKS" runat="server" CssClass="buttoninput" Text="Giao Viện kiểm sát" OnClick="cmdGiaoVKS_Click" />
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false"
                                        CssClass="back" Visible="true"
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
                                    <asp:DropDownList ID="dropPageSize" runat="server" Width="55px" CssClass="so"
                                        AutoPostBack="True" OnSelectedIndexChanged="dropPageSize_SelectedIndexChanged">
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
                            <div>
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkChonAll" AutoPostBack="true" OnCheckedChanged="chkChonAll_CheckChange" ToolTip="Chọn tất cả" runat="server" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkChon" ToolTip='<%#Eval("ID") +","+ Eval("LOAIAN_ID")%>' runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>STT</HeaderTemplate>
                                            <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="85px" Visible="false">
                                            <HeaderTemplate>
                                                Chọn vụ án
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:Button ID="cmdChitiet" runat="server" Text="Chọn vụ án"
                                                    CssClass="buttonchitiet"
                                                    CausesValidation="false" CommandName="Select" CommandArgument='<%#Eval("ID") %>' /></div>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                            <HeaderTemplate>
                                                Thông tin vụ án
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TenVuViec")%>
                                                <br />
                                                <i style='margin-right: 3px;'>Cấp xét xử:</i>  <b><%#Eval("GiaiDoanVuViec")%></b>
                                                <%#Eval("TruongHopGiaoNhan")%>
                                                <%#Eval("TenToaSoTham")%>
                                                <%#Eval("BANAN_QD_ST")%>
                                                <%#Eval("HoTenBiCan")%>
                                                <%#Eval("KHANGNGHI_ST")%>
                                                <asp:Literal ID="lttThongTin" runat="server"></asp:Literal>
                                                <asp:HiddenField ID="hddCHECK_THULY" runat="server" Value='<%#Eval("CHECK_THULY")%>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="TINHTRANG_GQ" HeaderText="Tình trạng GQ"
                                            HeaderStyle-Width="200px" ItemStyle-HorizontalAlign="left"
                                            HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="LOAI_AN_TEN" HeaderText="Loại án"
                                            HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="center"
                                            HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify" HeaderStyle-Width="90px">
                                            <HeaderTemplate>
                                                Người tạo
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div style="width: 90px;">
                                                    <%#Eval("NGUOITAO")%>
                                                </div>
                                                <%-- <i style="margin-right:3px;">Người tạo:</i>--%>
                                                <br />
                                                <%# Eval("NgayTao") %>
                                                <%--  <i style="margin-right:3px;">Ngày tạo:</i>--%>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Left" Width="90px"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Left" Width="90px"></ItemStyle>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Mã vụ án
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("Mavuviec")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center" Visible="false">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div style="display: none;">
                                                    <%#Eval("ID") %>
                                                    <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" ForeColor="#0e7eee"
                                                        CausesValidation="false" CommandName="Sua"
                                                        CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                    </br></br>
                                                <asp:LinkButton ID="lbtXoa" runat="server" ForeColor="#0e7eee"
                                                    CausesValidation="false" Text="Xóa"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"
                                                    OnClientClick="return confirm('Bạn thực sự muốn xóa vụ án này? ');"></asp:LinkButton>
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
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false"
                                        CssClass="back" Visible="true"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false"
                                        CssClass="active" Visible="false"
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
                                    <asp:DropDownList ID="dropPageSize2" runat="server" Width="55px" CssClass="so"
                                        AutoPostBack="True" OnSelectedIndexChanged="dropPageSize2_SelectedIndexChanged">
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
    </div>
    <script>
        function LoadDanhsachHoSo() {
            $("#<%= cmdTimkiem.ClientID %>").click();
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
