<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="TaoHosoHN.aspx.cs" Inherits="WEB.GSTP.QLAN.AHN.TaoHS.TaoHosoHN" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/QLAN/AHN/TaoHS/Popup/pDuongSuKhac.ascx" TagPrefix="uc1" TagName="DsDuongSu" %>
<%@ Register Src="~/QLAN/AHN/TaoHS/Popup/uDSNguoiThamGiaToTung.ascx" TagPrefix="uc1" TagName="uDSNguoiThamGiaToTung" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style type="text/css">
        .msg_error {
            width: 50% !important;
        }
    </style>
    <asp:HiddenField ID="hddID" runat="server" Value="0" />
    <asp:HiddenField ID="hddBAQDID" runat="server" Value="0" />
    <asp:HiddenField ID="hddKCID" runat="server" Value="0" />
    <asp:HiddenField ID="hddKNID" runat="server" Value="0" />
    <asp:HiddenField ID="hddShowKhangCao" Value="1" runat="server" />
    <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
               
                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                    <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
                </div>
                <div class="boxchung">
                    <h4 class="tleboxchung">Thông tin Hồ sơ Kháng cáo/ Kháng nghị</h4>
                    <div class="boder" style="padding: 10px;">
                        <table style="border-width: 0;border-collapse: collapse;border-spacing: 0; margin: 0px;padding: 0px;
                             font-size: 12px; font-family: Arial;">
                            <tr style="height:30px">
                                    <td style="width: 145px;">Loại</td>
                                    <td style="width: 500px; padding-right:10px"  colspan="3">  
                                        <asp:RadioButtonList ID="rdbLoaiBAQD" runat="server" AutoPostBack="True"  RepeatDirection="Horizontal"
                                            OnSelectedIndexChanged="rdbLoaiBAQD_SelectedIndexChanged">
                                            <asp:ListItem Value="1" Text="Bản án" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="0" Text="Quyết định"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                 </tr>
                            <asp:Panel ID="pnQD" Visible="false" runat="server">
                                <tr  style="height:30px">
                                    <td style="width: 145px;">Tên Quyết định ST<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddlQuyetdinh" CssClass="chosen-select" runat="server" Width="260px" AutoPostBack="True" OnSelectedIndexChanged="ddlQuyetdinh_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                          
                                
                                <tr  style="height:30px">
                                    <td  style="width: 145px;">Số Quyết định ST<span class="batbuoc">(*)</span></td>
                                    <td style="width: 260px; padding-right:10px;">
                                        <asp:TextBox ID="txtSoQD" runat="server" CssClass="user" Width="100" MaxLength="20"></asp:TextBox> 
                                    </td>
                                    <td style="width: 115px;" class="QDVACol3">Ngày quyết định ST<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayQD" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtNgayQD" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txtNgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                </tr>
                              </asp:Panel>
                              <asp:Panel ID="pnBanan" Visible="true" runat="server">
                                    <tr style="height:30px">
                                        <td style="width: 145px;">Số Bản án Sơ Thẩm<span class="batbuoc">(*)</span></td>
                                        <td style="width: 260px;  padding-right:10px;">
                                            <asp:TextBox ID="txtSobanan" CssClass="user" runat="server" Width="90px" MaxLength="250"></asp:TextBox>
                                        </td>
                                        <td style="width: 115px;">Ngày Bản án Sơ Thẩm<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtNgayBA" AutoPostBack="true" runat="server" CssClass="user"
                                                Width="95px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtNgayBA" Format="dd/MM/yyyy" BehaviorID="_content_CalendarExtender2" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtNgayBA" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" BehaviorID="_content_MaskedEditExtender3" Century="2000" CultureAMPMPlaceholder="SA;CH" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                                        </td>
                                    </tr>
                                </asp:Panel>
                                    <tr style="height:30px">
                                        <td style="width: 145px;">Tòa án Xét xử Sơ Thẩm<span class="batbuoc">(*)</span></td>
                                        <td style="text-align:left">
                                            <asp:DropDownList ID="ddlToaxxST" CssClass="chosen-select" runat="server" Width="260px" AutoPostBack="true">
                                            </asp:DropDownList>
                                        </td>
                                         <td style="width: 145px;">Tên vụ việc<span class="batbuoc">(*)</span></td>
                                        <td style="width: 250px; padding-right:10px;" colspan="3">
                                            <asp:TextBox ID="txtTenVuViec" CssClass="user" placeholder="Nguyên đơn - Bị đơn - Quan hệ pháp luật"
                                                runat="server" Width="250px"></asp:TextBox>
                                        </td>
                                        
                                    </tr>
                            </table>

                            <%--  --%>

                           <table>
                                <tr style="height:30px">
                                    <td>Quan hệ pháp luật <span class="batbuoc">(*)</span></td>
                                    <td  style="width: 145px;">
                                    <asp:DropDownList ID="ddlQuanhephapluat" Visible="false" CssClass="chosen-select" runat="server" Width="260px" AutoPostBack="True" OnSelectedIndexChanged="ddlQuanhephapluat_SelectedIndexChanged"></asp:DropDownList>
                                        <asp:TextBox ID="txtQuanhephapluat" CssClass="user" placeholder="" runat="server" Width="250px" MaxLength="500" TextMode="MultiLine"></asp:TextBox>

                                    </td>
                                    <td>QHPL dùng cho thống kê<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddlQHPLTK" CssClass="chosen-select" runat="server" Width="260px" AutoPostBack="true" OnSelectedIndexChanged="ddlQHPLTK_SelectedIndexChanged"></asp:DropDownList>
                                    </td>
                                    
                                   </tr>
                                <tr style="height:30px">
                                    <td style="width: 145px;">Người nhận Hồ sơ<span class="batbuoc">(*)</span></td>
                                    <td style="width: 260px; padding-right:10px;">
                                        <asp:DropDownList ID="ddlNguoinhanHS"  CssClass="chosen-select" Width="260px"  runat="server" AutoPostBack="true">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 145px;">Ngày nhận Hồ sơ<span class="batbuoc">(*)</span></td>
                                    <td style="width: 150px;">
                                        <asp:TextBox ID="txtNgayNhanHS" runat="server" AutoPostBack ="true" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayNhanHS" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgayNhanHS" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                    <td style="width: 145px;">Số bút lục Hồ sơ</td>
                                    <td style="width: 100px;">
                                        <asp:TextBox ID="txtSoButLuc" CssClass="user"  onkeypress="return isNumber(event)"  runat="server" Width="100px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr style="height:30px">
	                                <td style="width: 145px;">Trường hợp thụ lý Phúc thẩm<span class="batbuoc">(*)</span></td>
	                                <td style="width: 260px; padding-right:10px;">
		                                <asp:DropDownList ID="ddlThuly"  CssClass="chosen-select" Width="260px"  runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlThuly_SelectedIndexChanged">
			                                <asp:ListItem Text="Do có KC/KN" Value="0" />
			                                <asp:ListItem Text="Thụ lý lại xét xử PT" Value="1" />
		                                </asp:DropDownList>
	                                </td>
                                </tr>
                        </table>
                    </div>
                </div>
                <div class="boxchung">
                    <h4 class="tleboxchung"><asp:Label ID="lbl_ttnguyendon" Text="Thông tin nguyên đơn (đại diện)" runat="server"></asp:Label></h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td style="width: 115px;"> <asp:Label ID="lbl_nguyendonla" Text="Nguyên đơn là" runat="server"></asp:Label><span class="batbuoc">(*)</span></td>
                                <td style="width: 260px;">
                                    <asp:DropDownList ID="ddlLoaiNguyendon" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlLoaiNguyendon_SelectedIndexChanged">
                                        <asp:ListItem Value="1" Text="Cá nhân"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Cơ quan"></asp:ListItem>
                                        <asp:ListItem Value="3" Text="Tổ chức"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td colspan="2">
                                    <asp:CheckBox ID="chkISBVQLNK" Visible="false" runat="server" Text="Khởi kiện bảo vệ quyền và lợi ích hợp pháp của người khác, lợi ích công cộng và nhà nước" />
                                </td>
                            </tr>
                            <tr>
                                <td><asp:Label ID="lbl_tennguyendon" runat="server" Text="Tên nguyên đơn"></asp:Label><span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtTennguyendon" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>
                                <td colspan="2"></td>
                            </tr>
                            <asp:Panel ID="pnNDTochuc" runat="server" Visible="false">
                                <tr>
                                    <td>Địa chỉ</td>
                                    <td>
                                        <asp:DropDownList ID="ddlNDD_Tinh_NguyenDon" CssClass="chosen-select" runat="server" Width="123px" AutoPostBack="true" OnSelectedIndexChanged="ddlNDD_Tinh_NguyenDon_SelectedIndexChanged"></asp:DropDownList>
                                        <asp:DropDownList ID="ddlNDD_Huyen_NguyenDon" CssClass="chosen-select" runat="server" Width="123px"></asp:DropDownList>
                                    </td>
                                    <td>Chi tiết
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtND_NDD_Diachichitiet" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Người đại diện</td>
                                    <td>
                                        <asp:TextBox ID="txtND_NDD_Ten" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                    <td>Chức vụ</td>
                                    <td>
                                        <asp:TextBox ID="txtND_NDD_Chucvu" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                </tr>
                            </asp:Panel>
                            <tr>
                                <td>Số CMND/ Thẻ căn cước/ Hộ chiếu<asp:Literal ID="ltCMNDND" runat="server"></asp:Literal></td>
                                <td>
                                    <asp:TextBox ID="txtND_CMND" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                <td style="width: 70px;">Quốc tịch<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlND_Quoctich" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlND_Quoctich_SelectedIndexChanged"></asp:DropDownList></td>
                            </tr>
                            <tr>
                                    <td></td>
                                    <td colspan="3">
                                        <asp:CheckBox ID="chkBoxCMNDND" AutoPostBack="true" runat="server" Text="Không có" OnCheckedChanged="chkBoxCMNDND_CheckedChanged" />
                                    </td>
                                </tr>
                            <asp:Panel ID="pnNDCanhan" runat="server">
                                <tr>
                                    <td>Giới tính</td>
                                    <td>
                                        <asp:DropDownList ID="ddlND_Gioitinh" CssClass="chosen-select" runat="server" Width="250px">
                                            <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                            <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td>Ngày sinh</td>
                                    <td>
                                        <asp:TextBox ID="txtND_Ngaysinh" runat="server" CssClass="user" Width="65px" MaxLength="10" AutoPostBack="True" OnTextChanged="txtND_Ngaysinh_TextChanged"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtND_Ngaysinh" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtND_Ngaysinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        Năm sinh<span class="batbuoc">(*)</span>
                                        <asp:TextBox ID="txtND_Namsinh" CssClass="user" onkeypress="return isNumber(event)" runat="server" Width="35px" MaxLength="4" AutoPostBack="true" OnTextChanged="txtND_Namsinh_TextChanged"></asp:TextBox>
                                          </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td colspan="3">
                                        <asp:CheckBox ID="chkND_ONuocNgoai" AutoPostBack="true" runat="server" Text="Có yếu tố nước ngoài" OnCheckedChanged="chkND_ONuocNgoai_CheckedChanged" />
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td>Nơi cư trú<asp:Label ID="lblND_Batbuoc2" runat="server" ForeColor="Red" Text="(*)"></asp:Label></td>
                                    <td>
                                        <asp:DropDownList ID="ddlTamTru_Tinh_NguyenDon" CssClass="chosen-select" runat="server" Width="123px" AutoPostBack="true" OnSelectedIndexChanged="ddlTamTru_Tinh_NguyenDon_SelectedIndexChanged"></asp:DropDownList>
                                        <asp:DropDownList ID="ddlTamTru_Huyen_NguyenDon" CssClass="chosen-select" runat="server" Width="123px"></asp:DropDownList>
                                    </td>
                                    <td>Chi tiết</td>
                                    <td>
                                        <asp:TextBox ID="txtND_TTChitiet" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Nơi làm việc</td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtND_NoiLamViec" CssClass="user" runat="server" Width="590px" MaxLength="500"></asp:TextBox>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <tr>
                                <td>Email</td>
                                <td>
                                    <asp:TextBox ID="txtND_Email" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                <td>Điện thoại</td>
                                <td>
                                    <asp:TextBox ID="txtND_Dienthoai" runat="server" onkeypress="return isNumber(event)" CssClass="user" Width="103px"></asp:TextBox>
                                    Fax
                                    <asp:TextBox ID="txtND_Fax" runat="server" onkeypress="return isNumber(event)" CssClass="user" Width="103px"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="boxchung" runat="server" id="div_bidon">
                    <h4 class="tleboxchung"><asp:Label ID="lbl_ttbidon" Text="Thông tin bị đơn (đại diện)" runat="server"></asp:Label></h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td style="width: 115px;"><asp:Label ID="lbl_bidonla" Text="Bị đơn là" runat="server"></asp:Label><span class="batbuoc">(*)</span></td>
                                <td style="width: 260px;">
                                    <asp:DropDownList ID="ddlLoaiBidon" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlLoaiBidon_SelectedIndexChanged">
                                        <asp:ListItem Value="1" Text="Cá nhân"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Cơ quan"></asp:ListItem>
                                        <asp:ListItem Value="3" Text="Tổ chức"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 70px;"><%--Mã bị đơn--%></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td><asp:Label ID="lbl_tenbidon" runat="server" Text="Tên bị đơn"></asp:Label><span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtBD_Ten" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>
                                <td colspan="2"></td>
                            </tr>
                            <asp:Panel ID="pnBD_Tochuc" runat="server" Visible="false">
                                <tr>
                                    <td>Địa chỉ</td>
                                    <td>
                                        <asp:DropDownList ID="ddlNDD_Tinh_BiDon" CssClass="chosen-select" runat="server" Width="123px" AutoPostBack="true" OnSelectedIndexChanged="ddlNDD_Tinh_BiDon_SelectedIndexChanged"></asp:DropDownList>
                                        <asp:DropDownList ID="ddlNDD_Huyen_BiDon" CssClass="chosen-select" runat="server" Width="123px"></asp:DropDownList>
                                    </td>
                                    <td>Chi tiết</td>
                                    <td>
                                        <asp:TextBox ID="txtBD_NDD_Diachichitiet" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Người đại diện</td>
                                    <td>
                                        <asp:TextBox ID="txtBD_NDD_ten" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                    <td>Chức vụ</td>
                                    <td>
                                        <asp:TextBox ID="txtBD_NDD_Chucvu" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                </tr>
                            </asp:Panel>
                            <tr>
                                <td>Số CMND/ Thẻ căn cước/ Hộ chiếu<asp:Literal ID="ltCMNDBD" runat="server"></asp:Literal></td>
                                <td>
                                    <asp:TextBox ID="txtBD_CMND" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                <td>Quốc tịch<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlBD_Quoctich" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlBD_Quoctich_SelectedIndexChanged"></asp:DropDownList></td>
                            </tr>
                             <tr>
                                    <td></td>
                                    <td colspan="3">
                                        <asp:CheckBox ID="chkBoxCMNDBD" AutoPostBack="true" runat="server" Text="Không có" OnCheckedChanged="chkBoxCMNDBD_CheckedChanged" />
                                    </td>
                                </tr>
                            <asp:Panel ID="pnBD_Canhan" runat="server">
                                <tr>
                                    <td>Giới tính</td>
                                    <td>
                                        <asp:DropDownList ID="ddlBD_Gioitinh" CssClass="chosen-select" runat="server" Width="250px">
                                            <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                            <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                                        </asp:DropDownList>
                                    <td>Ngày sinh</td>
                                    <td>
                                        <asp:TextBox ID="txtBD_Ngaysinh" runat="server" CssClass="user" Width="65px" MaxLength="10" AutoPostBack="True" OnTextChanged="txtBD_Ngaysinh_TextChanged"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtBD_Ngaysinh" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtBD_Ngaysinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        Năm sinh
                                        <asp:TextBox ID="txtBD_Namsinh" CssClass="user" runat="server" onkeypress="return isNumber(event)" Width="35px" MaxLength="4" AutoPostBack="true" OnTextChanged="txtBD_Namsinh_TextChanged"></asp:TextBox>
                                        <%--    Tuổi
                                        <asp:TextBox ID="txtBD_Tuoi" CssClass="user" onkeypress="return isNumber(event)" runat="server" Width="20px" MaxLength="2"></asp:TextBox>
                                        --%> </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td colspan="3">
                                        <asp:CheckBox ID="chkBD_ONuocNgoai" AutoPostBack="true" runat="server" Text="Có yếu tố nước ngoài" OnCheckedChanged="chkBD_ONuocNgoai_CheckedChanged" />
                                    </td>

                                </tr>
                               
                                <tr>
                                    <td>Nơi cư trú</td>
                                    <td>
                                        <asp:DropDownList ID="ddlTamTru_Tinh_BiDon" CssClass="chosen-select" runat="server" Width="123px" AutoPostBack="true" OnSelectedIndexChanged="ddlTamTru_Tinh_BiDon_SelectedIndexChanged"></asp:DropDownList>
                                        <asp:DropDownList ID="ddlTamTru_Huyen_BiDon" CssClass="chosen-select" runat="server" Width="123px"></asp:DropDownList>
                                    </td>
                                    <td>Chi tiết</td>
                                    <td>

                                        <asp:TextBox ID="txtBD_Tamtru_Chitiet" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Nơi làm việc</td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtBD_NoiLamViec" CssClass="user" runat="server" Width="590px" MaxLength="500"></asp:TextBox>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <tr>
                                <td>Email</td>
                                <td>
                                    <asp:TextBox ID="txtBD_Email" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                <td>Điện thoại</td>
                                <td>
                                    <asp:TextBox ID="txtBD_Dienthoai" runat="server" onkeypress="return isNumber(event)" CssClass="user" Width="103px"></asp:TextBox>
                                    Fax
                                    <asp:TextBox ID="txtBD_Fax" runat="server" onkeypress="return isNumber(event)" CssClass="user" Width="103px"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <%--  --%>
                <asp:Panel ID="pnThemDS" runat="server" Visible="false">
                <div class="boxchung">
                        <h4 class="tleboxchung bg_title_group bg_yellow">Thêm đương sự khác</h4>
                        <div class="boder" style="padding: 5px 10px;">
                            <asp:LinkButton ID="lkThemDuongSuKhac" runat="server" CssClass="buttonpopup them_user" OnClick="lkThemDuongSuKhac_Click">Thêm đương sự khác</asp:LinkButton>
                            <uc1:DsDuongSu runat="server" ID="DsDuongSu1" />
                        </div>
                 </div>
                </asp:Panel>
                 <!-------------------------------->
                 <asp:Panel ID="pnNguoiTGTT" runat="server" Visible="false">
                   <div class="boxchung">
                        <h4 class="tleboxchung bg_title_group bg_yellow">Danh sách người tham gia tố tụng</h4>
                        <div class="boder" style="padding: 5px 10px;">
                            <asp:LinkButton ID="lkThemNguoiTGTT" runat="server"
                                OnClick="lkThemNguoiTGTT_Click" CssClass="buttonpopup them_user">Thêm người tham gia tố tụng</asp:LinkButton>

                            <uc1:uDSNguoiThamGiaToTung runat="server" id="uDSNguoiThamGiaToTung" />
                        </div>
                    </div>
                 </asp:Panel>

                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                    <asp:Literal ID="lstMsgB" runat="server"></asp:Literal>
                </div>
                <div style="margin: 5px; text-align: center; width: 95%; margin-bottom: 70px;">
                    <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu Hồ sơ" OnClick="cmdUpdate_Click" />
                    
                </div>
            </div>

        <div class="box_nd" style="width: 99%;">
            <asp:Panel ID="pnKhangCao" runat="server" Visible="true">
                <div class="boxchung">
                    <h4 class="tleboxchung">Thông tin kháng cáo</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td colspan="4">
                                    <asp:RadioButtonList ID="rdbPanelKC" runat="server" RepeatDirection="Horizontal" Font-Bold="true" AutoPostBack="true" OnSelectedIndexChanged="rdbPanelKC_SelectedIndexChanged">
                                        <asp:ListItem Value="1" Text="Kháng cáo" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Kháng nghị"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td>Hình thức nhận đơn<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rdbHinhThucNhanDon" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="0" Text="Trực tiếp"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Qua bưu điện"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                                <td colspan="2"></td>
                            </tr>
                            <tr>
                                <td class="KCHNCol1">Ngày viết đơn KC</td>
                                <td class="KCHNCol2">
                                    <asp:TextBox ID="txtNgayvietdonKC" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayvietdonKC" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayvietdonKC" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td class="KCHNCol3">Ngày kháng cáo<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgaykhangcao" runat="server"
                                        AutoPostBack ="true"
                                        CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgaykhangcao" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgaykhangcao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>
                                <td>Tên người kháng cáo<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlNguoikhangcao" CssClass="chosen-select" runat="server"  Width="200px"></asp:DropDownList>
                                </td>
                                <td>Loại kháng cáo<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rdbLoaiKC" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbLoaiKC_SelectedIndexChanged">
                                        <asp:ListItem Value="0" Text="Bản án" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Quyết định" Selected="True"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td>Số QĐ/BA<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlSOQDBA_KC" CssClass="chosen-select" runat="server"  Width="200px" AutoPostBack="True" OnSelectedIndexChanged="ddlSOQDBA_KC_SelectedIndexChanged"></asp:DropDownList>
                                </td>
                                <td>Kháng cáo quá hạn<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rdbQuahan_KC" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="0" Text="Không" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td>Ngày QĐ/BA</td>
                                <td>
                                    <asp:TextBox ID="txtNgayQDBA_KC" Enabled="false" runat="server" ReadOnly="true" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayQDBA_KC" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayQDBA_KC" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td>Tòa án ra QĐ/BA</td>
                                <td>
                                    <asp:TextBox ID="txtToaAnQD_KC" ReadOnly="true" Enabled="false" 
                                        runat="server" CssClass="user" Width="100%" ></asp:TextBox>
                                </td>

                            </tr>
                            <tr>
                                <td>Nội dung kháng cáo<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtNoidungKC" runat="server" CssClass="user" Width="99.8%" TextMode="MultiLine" Height="50px"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                       
                    </div>
                </div>
            </asp:Panel>
            <asp:Panel ID="pnKhangNghi" runat="server" Visible="false">
                <div class="boxchung">
                    <h4 class="tleboxchung">Thông tin kháng nghị</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td colspan="4">
                                    <asp:RadioButtonList ID="rdbPanelKN" runat="server" RepeatDirection="Horizontal" Font-Bold="true" AutoPostBack="true" OnSelectedIndexChanged="rdbPanelKN_SelectedIndexChanged">
                                        <asp:ListItem Value="1" Text="Kháng cáo" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Kháng nghị"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td>Tòa án ra QĐ/BA</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtToaAnQD_KN" ReadOnly="true" Enabled="false" runat="server" CssClass="user" Width="242px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 135px;">Người Kháng nghị<span class="batbuoc">(*)</span></td>
                                <td style="width: 250px;">
                                    <asp:RadioButtonList ID="rdbDonVi" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbDonVi_SelectedIndexChanged">
                                        <asp:ListItem Value="0" Text="Chánh án"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Viện trưởng"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                                <td style="width: 115px;">Cấp kháng nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rdbCapkhangnghi" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbCapkhangnghi_SelectedIndexChanged">
                                        <asp:ListItem Value="0" Text="Cùng cấp"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Cấp trên"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr id="trDVKN" runat="server" visible="false">
                                <td>Đơn vị kháng nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlDonViKN" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList></td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td>Số kháng nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtSokhangnghi" runat="server" CssClass="user" Width="242px" MaxLength="20"></asp:TextBox>
                                </td>
                                <td>Ngày kháng nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgaykhangnghi" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender10" runat="server" TargetControlID="txtNgaykhangnghi" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender10" runat="server" TargetControlID="txtNgaykhangnghi" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>

                                <td>Loại kháng nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rdbLoaiKN" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbLoaiKN_SelectedIndexChanged">
                                        <asp:ListItem Value="0" Text="Bản án"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Quyết định" Selected="true"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td>Số QĐ/BA<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlSOQDBAKhangNghi" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlSOQDBAKhangNghi_SelectedIndexChanged"></asp:DropDownList>
                                </td>
                                <td>Ngày QĐ/BA</td>
                                <td>
                                    <asp:TextBox ID="txtNgayQDBA_KN" runat="server" ReadOnly="true" Enabled="false" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender11" runat="server" TargetControlID="txtNgayQDBA_KN" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender11" runat="server" TargetControlID="txtNgayQDBA_KN" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>

                            <tr>
                                <td>Nội dung kháng nghị<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtNoidungKN" runat="server" CssClass="user" Width="100%" TextMode="MultiLine" Height="50px" MaxLength="1000"></asp:TextBox>
                                </td>
                            </tr>
                            
                        </table>
                    </div>
                </div>
            </asp:Panel>
        </div>
        <asp:Panel ID="lastPanel" runat="server">
         <div class="truong">
                <table class="table1">
                    <tr><td colspan="2" align ="center">
                        <asp:Button ID="cmdUpdateKCKN" runat="server" CssClass="buttoninput" Text="Lưu KC/KN"
                     OnClientClick="return validateKCKN();"   OnClick="cmdUpdateKCKN_Click" />
                        </td></tr>
                    <tr>
                        <td colspan="2">
                            <div>
                                
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                            </div>
                            <asp:Panel runat="server" ID="pndata" Visible="false">
                               
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="200" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>TT</HeaderTemplate>
                                            <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="KCKNName" HeaderText="Kháng cáo, Kháng nghị" HeaderStyle-Width="66px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="HTNhanDonDonViKN" HeaderText="Hình thức nhận đơn KC, Đơn vị kháng nghị" HeaderStyle-Width="96px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NguoiKCCapKN" HeaderText="Người kháng cáo, Cấp kháng nghị" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="LoaiKCKN" HeaderText="Loại" HeaderStyle-Width="118px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NgayKCKN" HeaderText="Ngày kháng cáo, kháng nghị" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="SO_QDBA" HeaderText="Số BA/QĐ" HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYQDBA" HeaderText="Ngày QĐ/BA" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <%--<asp:BoundColumn DataField="NGUOITAO" HeaderText="Người tạo" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYTAO" HeaderText="Ngày tạo" HeaderStyle-Width="94px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>--%>
                                        <asp:TemplateColumn HeaderStyle-Width="105px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Thao tác</HeaderTemplate>
                                            <ItemTemplate>
                                               
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") +";#"+ Eval("IsKhangCao")%>'></asp:LinkButton>
                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") +";#"+ Eval("IsKhangCao")%>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
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
            </asp:Panel>                  
                    
            <div align ="center">
                    <asp:Button ID="cmdUpdateSelect" runat="server" CssClass="buttoninput" Text="Lưu & Chọn xử lý"
                                OnClick="cmdUpdateSelect_Click" />
                
                <%-- Tạm thời ngắt nút xoá, vì Nếu phân quyền "XEM" thì vẫn có quyền xoá
                    Và nếu Toà phúc thẩm có quyền xem thì cũng có quyền xoá, dẫn đến việc mất dữ liệu của toà cấp sơ thẩm
                    01/11/2024--%>
                    <asp:Button ID="cmdXoaHoSo" runat="server" CssClass="buttoninput" Text="Xóa"
                      OnClientClick="return confirm('Bạn thực sự muốn xóa Hồ sơ này? ');"  OnClick="cmdXoaHoSo_Click" />
             </div>

        </div>
    </div>
    <%--  --%>
    <div style="display: none">
        <asp:Button ID="cmdLoadDsDuongSuKhac" runat="server"
            Text="Load ds Dương sự khac" OnClick="cmdLoadDsDuongSuKhac_Click" />
        <asp:Button ID="cmdLoadDsNguoiTGTT" runat="server"
            Text="Load ds nguoi TGTT" OnClick="cmdLoadDsNguoiTGTT_Click" />
    </div>
    <script>
        function LoadDsNguoiDuongSu() {
            // alert('goi load ds bi can + toi danh bi can dau vu');
            $("#<%= cmdLoadDsDuongSuKhac.ClientID %>").click();
        }
        function LoadDsNguoiThamGiaTT() {
            //alert('ds nguoi tham gia tt form parent');
            $("#<%= cmdLoadDsNguoiTGTT.ClientID %>").click();
        }
    </script>
    <%--  --%>


    <script type="text/javascript">

        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: false }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        function Setfocus(controlid) {
            var ctrl = document.getElementById(controlid);
            ctrl.focus();
        }
         function validateKCKN() {

            var hddShowKhangCao = document.getElementById('<%=hddShowKhangCao.ClientID%>');
         
            var pnKhangCao = document.getElementById('<%=pnKhangCao.ClientID%>');
            if (hddShowKhangCao.value == "1")
                return validate_khangcao();
            else
                return validate_khangnghi();
            return true;
        }
        function validate_khangcao() {
            var rdbHinhThucNhanDon = document.getElementById('<%=rdbHinhThucNhanDon.ClientID%>');
            var msg = 'Bạn chưa chọn hình thức nhận đơn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdbHinhThucNhanDon, msg))
                return false;
            //-----------------------------------
            var KC_txtNgayvietdon = document.getElementById('<%=txtNgayvietdonKC.ClientID%>');
            if (Common_CheckEmpty(KC_txtNgayvietdon.value)) {
                if (!CheckDateTimeControl(KC_txtNgayvietdon, 'Ngày viết đơn'))
                    return false;
            }

            //-----------------------------------
            var KC_txtNgaykhangcao = document.getElementById('<%=txtNgaykhangcao.ClientID%>');
            if (!CheckDateTimeControl(KC_txtNgaykhangcao, 'Ngày kháng cáo'))
                return false;

            //-----------------------------------
            var KC_ddlNguoikhangcao = document.getElementById('<%=ddlNguoikhangcao.ClientID%>');
            var val = KC_ddlNguoikhangcao.options[KC_ddlNguoikhangcao.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn người kháng cáo. Hãy kiểm tra lại!');
                KC_ddlNguoikhangcao.focus();
                return false;
            }
            //-----------------------------------
            var rdbLoaiKC = document.getElementById('<%=rdbLoaiKC.ClientID%>');
            msg = 'Bạn chưa chọn loại kháng cáo. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdbLoaiKC, msg))
                return false;
            //-----------------------------------
            var ddlSOQDBA_KC = document.getElementById('<%=ddlSOQDBA_KC.ClientID%>');
            var val = ddlSOQDBA_KC.options[ddlSOQDBA_KC.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn số QĐ/BA. Hãy kiểm tra lại!');
                ddlSOQDBA_KC.focus();
                return false;
            }
            //-----------------------------------
            var rdbQuahan_KC = document.getElementById('<%=rdbQuahan_KC.ClientID%>');
            msg = 'Mục "Kháng cáo quá hạn" chưa được chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdbQuahan_KC, msg))
                return false;

            //-----------------------------------
            return true;
        }
        function validate_khangnghi()
        {
            var txtSokhangnghi = document.getElementById('<%=txtSokhangnghi.ClientID%>');
            if (!Common_CheckTextBox(txtSokhangnghi,"Số kháng nghị")) {
                return false;
            }

            var lengthSoKN = txtSokhangnghi.value.trim().length;
            if (lengthSoKN > 20) {
                alert('Số kháng nghị không quá 20 ký tự. Hãy nhập lại!');
                txtSokhangnghi.focus();
                return false;
            }
            //-----------------------------
            var txtNgaykhangnghi = document.getElementById('<%=txtNgaykhangnghi.ClientID%>');
            if (!CheckDateTimeControl(txtNgaykhangnghi, 'Ngày kháng nghị'))
                return false;

            //-----------------------------
            var rdbCapkhangnghi = document.getElementById('<%=rdbCapkhangnghi.ClientID%>');
            msg = 'Bạn chưa chọn cấp kháng nghị. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdbCapkhangnghi, msg))
                return false;
            //-----------------------------
            var rdbLoaiKN = document.getElementById('<%=rdbLoaiKN.ClientID%>');
            msg = 'Bạn chưa chọn loại kháng nghị. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdbLoaiKN, msg))
                return false;
            //-----------------------------
            var ddlSOQDBAKhangNghi = document.getElementById('<%=ddlSOQDBAKhangNghi.ClientID%>');
            var val = ddlSOQDBAKhangNghi.options[ddlSOQDBAKhangNghi.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn số QĐ/BA. Hãy kiểm tra lại!');
                ddlSOQDBAKhangNghi.focus();
                return false;
            }
            //-----------------------------
            var txtNoidung = document.getElementById('<%=txtNoidungKN.ClientID%>');
            if (Common_CheckEmpty(txtNgaynopanphi.value)) {
                var noidung_length = txtNoidung.value.trim().length;
                if (noidung_length > 1000) {
                    alert('Nội dung kháng nghị không quá 1000 ký tự. Hãy nhập lại!');
                    txtNoidung.focus();
                    return false;
                }
            }
            return true;
        }

    </script>
</asp:Content>
