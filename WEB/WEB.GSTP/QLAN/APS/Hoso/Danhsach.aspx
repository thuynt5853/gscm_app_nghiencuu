<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.QLAN.APS.Hoso.Danhsach" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />    
    
    <div id = "divBackground" style=" position:absolute; top:0px; left:0px;background-color:black; z-index:100;opacity: 0.8;filter:alpha(opacity=60); -moz-opacity: 0.8; overflow:hidden; display:none"></div>
<%--    <asp:Button ID="cmdLoadNhapAn" runat="server" style="display: none;" disable="false" OnClick="cmdLoadNhapAn_Click" />
    <asp:Button ID="cmdLoadTachAn" runat="server" style="display: none;" disable="false" OnClick="cmdLoadTachAn_Click" />--%>

    <div class="box">

        <div class="box_nd">
            <h4 style="float: right; text-align: right; margin-right: 10px;">
                <asp:LinkButton ID="LinkButtonAnPhi" runat="server" Text="[ Danh sách biên lai tạm ứng án phí trực tuyến từ DVC / THADS ]" ForeColor="#0E7EEE" OnClick="lbtDanhSachAnPhi_Click"></asp:LinkButton>
            </h4>
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Tìm kiếm
                                    <asp:LinkButton ID="lbtTTTK" runat="server" Text="[ Nâng cao ]" ForeColor="#0E7EEE" OnClick="lbtTTTK_Click"></asp:LinkButton>
                                </h4>
                                <div class="boder" style="padding: 10px;">
                                    <!--duongph 21/03/2022 -->
                                    <table class="table1">
                                        <tr>
                                            <div style="float: left; width: 1050px; margin-top: 4px;">
	                                            <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tên việc</div>
	                                            <div style="float: left;">
		                                            <asp:TextBox ID="txtTenViec" CssClass="user" runat="server" Width="240px"></asp:TextBox>
	                                            </div>
	                                            <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Loại hình doanh nghiệp</div>
	                                            <div style="float: left;">
		                                            <asp:DropDownList ID="ddlLoaiHinhDoanhNghiep" CssClass="chosen-select" runat="server" Width="246px"></asp:DropDownList>
	                                            </div>
	                                            <%--<div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Mã vụ án</div>--%>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">
                                                            <asp:DropDownList ID="DropMA_THONG_BAO" Width="60px" runat="server">
                                                                <asp:ListItem Value="1" Text="Mã vụ án" Selected="True"></asp:ListItem>
                                                                <asp:ListItem Value="2" Text="Mã TB án phí"></asp:ListItem>
                                                            </asp:DropDownList>
                                                    </div>
	                                            <div style="float: left;">
		                                            <asp:TextBox ID="txtMaViec" CssClass="user" runat="server" Width="242px"></asp:TextBox>
	                                            </div>
                                            </div>
                                            <div style="float: left; width: 1050px; margin-top: 4px;">
	                                            <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Đương sự/ Người tham gia tố tụng</div>
	                                            <div style="float: left;">
		                                            <asp:TextBox ID="txtDuongSu_NguoiThamGiaToTung" CssClass="user" runat="server" Width="240px"></asp:TextBox>
	                                            </div>
	                                            <div style="float: left; width: 80px; text-align: right; margin-right: 10px; padding-top:7px;">Cấp xét xử</div>
	                                            <div style="float: left;">
		                                            <asp:DropDownList ID="ddlCapXetXu" CssClass="chosen-select" runat="server" Width="246px" AutoPostBack="true" OnSelectedIndexChanged="ddlCapXetXu_SelectedIndexChanged"></asp:DropDownList>
	                                            </div>
	                                            <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Toà xét xử</div>
	                                            <div style="float: left;">
		                                            <asp:DropDownList ID="ddlToaAnXetXu" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="true" OnSelectedIndexChanged="ddlToaAnXetXu_SelectedIndexChanged"></asp:DropDownList>
	                                            </div>
                                            </div>
                                            <asp:Panel ID="pnTTTK" runat="server" Visible="false">
                                            <div style="float: left; width: 1050px" margin-top: 4px;">
	                                            <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tình trạng thụ lý</div>
	                                            <div style="float: left;">
		                                            <asp:DropDownList ID="ddlTinhTrangThuLy" CssClass="chosen-select" runat="server" Width="248px">
			                                            <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
			                                            <asp:ListItem Value="1" Text="Đã thụ lý"></asp:ListItem>
			                                            <asp:ListItem Value="2" Text="Chưa thụ lý"></asp:ListItem>
		                                            </asp:DropDownList>
	                                            </div>
	                                            <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Từ ngày</div>
	                                            <div style="float: left;">
		                                            <asp:TextBox ID="txtTuNgayThuly" CssClass="user" runat="server" Width="70px" MaxLength="10"></asp:TextBox>
		                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtTuNgayThuly" Format="dd/MM/yyyy" Enabled="true" />
		                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgayThuly" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
		                                            <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgayThuly" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
	                                            </div>
	                                            <div style="float: left; width: 75px; text-align: center;">Đến ngày</div>
	                                            <div style="float: left;">
	                                            <asp:TextBox ID="txtDenNgayThuLy" CssClass="user" runat="server" Width="70px" MaxLength="10"></asp:TextBox>
		                                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtDenNgayThuLy" Format="dd/MM/yyyy" Enabled="true" />
		                                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgayThuLy" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
		                                            <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtDenNgayThuLy" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
	                                            </div>
	                                            <div style="float: left; width: 65px; text-align: right; margin-right: 10px;">Số thụ lý</div>
	                                            <div style="float: left;">
		                                            <asp:TextBox ID="txtSoThuLy" CssClass="user" runat="server" Width="242px"></asp:TextBox>
	                                            </div>
                                            </div>
                                            <div style="float: left; width: 1050px; margin-top: 4px;">
	                                            <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tình trạng GQ</div>
	                                            <div style="float: left;">
		                                            <asp:DropDownList ID="ddlTinhTrangGQ" CssClass="chosen-select" runat="server" Width="248px">
			                                            <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
			                                            <asp:ListItem Value="1" Text="+ Chưa giải quyết xong" Selected="True"></asp:ListItem>
			                                            <asp:ListItem Value="2" Text="....Chưa phân công Thẩm phán"></asp:ListItem>
			                                            <asp:ListItem Value="3" Text="....Đã phân công Thẩm phán"></asp:ListItem>
			                                            <asp:ListItem Value="4" Text="....Đã lên lịch họp"></asp:ListItem>
			                                            <asp:ListItem Value="5" Text="....Đang hoãn"></asp:ListItem>
			                                            <asp:ListItem Value="6" Text="....Đang tạm đình chỉ"></asp:ListItem>
			                                            <asp:ListItem Value="7" Text="+ Đã giải quyết xong"></asp:ListItem>
			                                            <asp:ListItem Value="8" Text="....QĐ không mở thủ tục phá sản"></asp:ListItem>
			                                            <asp:ListItem Value="9" Text="....QĐ tuyên bố phá sản"></asp:ListItem>
			                                            <asp:ListItem Value="10" Text="....QĐ đình chỉ tiến hành thủ tục phá sản"></asp:ListItem>
		                                            </asp:DropDownList>
	                                            </div>
	                                            <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Từ ngày</div>
	                                            <div style="float: left;">
		                                            <asp:TextBox ID="txtTuNgayTinhTrangGQ" CssClass="user" runat="server" Width="70px" MaxLength="10"></asp:TextBox>
		                                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtTuNgayTinhTrangGQ" Format="dd/MM/yyyy" Enabled="true" />
		                                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtTuNgayTinhTrangGQ" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
		                                            <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgayTinhTrangGQ" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
	                                            </div>
	                                            <div style="float: left; width: 75px; text-align: center;">Đến ngày</div>
	                                            <div style="float: left;">
		                                            <asp:TextBox ID="txtDenNgayTinhTrangGQ" CssClass="user" runat="server" Width="70px" MaxLength="10"></asp:TextBox>
		                                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtDenNgayTinhTrangGQ" Format="dd/MM/yyyy" Enabled="true" />
		                                            <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtDenNgayTinhTrangGQ" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
		                                            <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtDenNgayTinhTrangGQ" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
	                                            </div>
	                                            <div style="float: left; width: 65px; text-align: right; margin-right: 10px;">Thẩm phán</div>
	                                            <div style="float: left;">
		                                            <asp:DropDownList ID="ddlThamphan" CssClass="chosen-select" runat="server" Width="250px" OnSelectedIndexChanged="ddlThamphan_SelectedIndexChanged"></asp:DropDownList>
	                                            </div>
                                            </div>
                                            <div style="float: left; width: 1050px; margin-top: 4px;">
	                                            <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Thời hạn GQ</div>
	                                            <div style="float: left;">
		                                            <asp:DropDownList ID="ddlThoiHanGQ" CssClass="chosen-select" runat="server" Width="248px">
			                                            <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
			                                            <asp:ListItem Value="1" Text="Đã hết thời hạn"></asp:ListItem>
			                                            <asp:ListItem Value="2" Text="Còn thời hạn dưới 10 ngày"></asp:ListItem>
			                                            <asp:ListItem Value="3" Text="Còn thời hạn dưới 20 ngày"></asp:ListItem>
		                                            </asp:DropDownList>
	                                            </div>
	                                            <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Số QĐ</div>
	                                            <div style="float: left;">
		                                            <asp:TextBox ID="txtSoQD" CssClass="user" runat="server" Width="70px" MaxLength="10"></asp:TextBox>
	                                            </div>
	                                            <div style="float: left; width: 90px; text-align: center;">Ngày QĐ</div>
	                                            <div style="float: left;">
		                                            <asp:TextBox ID="txtNgayQD" CssClass="user" runat="server" Width="70px" MaxLength="10"></asp:TextBox>
		                                            <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayQD" Format="dd/MM/yyyy" Enabled="true" />
		                                            <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
		                                            <cc1:MaskedEditValidator ID="MaskedEditValidator5" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayQD" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
	                                            </div>
                                                <div style="float: left; width: 65px; text-align: right; margin-right: 10px;">Vai trò của Thẩm phán</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="ddlVaiTroThamPhan" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                        </div>
	                                            <%--<div style="float: left; width: 65px; text-align: right; margin-right: 10px;">Thư ký</div>
	                                            <div style="float: left;">
		                                            <asp:DropDownList ID="ddlThuKy" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
	                                            </div>--%>
                                            </div>
                                            <div style="float: left; width: 1050px; margin-top: 4px;">
	                                            <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Kết quả GQ đơn</div>
	                                            <div style="float: left;">
		                                            <asp:DropDownList ID="ddlGQDon" CssClass="chosen-select" runat="server" Width="246px">
			                                            <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
			                                            <asp:ListItem Value="5" Text="Thụ lý"></asp:ListItem>
			                                            <asp:ListItem Value="4" Text="Yêu cầu bổ sung đơn"></asp:ListItem>
			                                            <asp:ListItem Value="1" Text="Chuyển đơn cho Tòa án khác"></asp:ListItem>
			                                            <asp:ListItem Value="3" Text="Trả lại đơn"></asp:ListItem>
			                                            <asp:ListItem Value="6" Text="Đơn chưa giải quyết"></asp:ListItem>
			                                            <asp:ListItem Value="7" Text="Đơn quá hạn chưa giải quyết"></asp:ListItem>
			                                            <asp:ListItem Value="8" Text="Đơn chưa phân công TP giải quyết"></asp:ListItem>
		                                            </asp:DropDownList>
	                                            </div>
	                                            <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Ủy thác thư pháp</div>
	                                            <div style="float: left;">
		                                            <asp:DropDownList ID="ddlUyThacTuPhap" CssClass="chosen-select" runat="server" Width="246px">
			                                            <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
			                                            <asp:ListItem Value="1" Text="Không có ủy thác đi"></asp:ListItem>
			                                            <asp:ListItem Value="2" Text="Có ủy thác đi"></asp:ListItem>
		                                            </asp:DropDownList>
	                                            </div>
	                                            <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Thư ký</div>
	                                            <div style="float: left;">
		                                            <asp:DropDownList ID="ddlThuKy" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
	                                            </div>
                                                 <%-- <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">PT rút kinh nghiệm</div>
	                                            <div style="float: left;">
		                                            <asp:DropDownList ID="ddlPTRutKinhNghiem" CssClass="chosen-select" runat="server" Width="250px">
			                                            <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
			                                            <asp:ListItem Value="1" Text="Có"></asp:ListItem>
			                                            <asp:ListItem Value="2" Text="Không"></asp:ListItem>
		                                            </asp:DropDownList>
	                                            </div>
                                                 --%>
                                                <div style="float: left; width: 1050px; margin-top: 8px;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Trạng thái nhập/tách</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="ddlTrangThaiVuAn" CssClass="chosen-select" runat="server" Width="248px">
                                                                <asp:ListItem Value="0" Text="-- Tất cả --"></asp:ListItem>
                                                                <asp:ListItem Value="1" Text="Đã nhập"></asp:ListItem>
                                                                <asp:ListItem Value="2" Text="Đã tách"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">PT rút kinh nghiệm</div>
	                                            <div style="float: left;">
		                                            <asp:DropDownList ID="ddlPTRutKinhNghiem" CssClass="chosen-select" runat="server" Width="250px">
			                                            <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
			                                            <asp:ListItem Value="1" Text="Có"></asp:ListItem>
			                                            <asp:ListItem Value="2" Text="Không"></asp:ListItem>
		                                            </asp:DropDownList>
	                                            </div>
                                                </div>
                                                </div>
                                                <div style="float: left; width: 1050px; margin-top: 8px;">
                                                    
                                                    <div style="float: left; width: 120px; text-align: right; margin-right: 10px;">Thao tác nhập tách</div>
                                                    <div style="float: left;">
                                                        <asp:CheckBox ID="chkNhapTach" runat="server" AutoPostBack="true" OnCheckedChanged="chkNhapTach_CheckedChanged"/>
                                                    </div>
                                                      <div style="float: left; width: 500px; text-align: right; margin-right: 10px;">GQ KC/KN QĐ tạm đình chỉ và QĐ khác</div>
                                                        <div style="float: left;">
                                                            <asp:CheckBox ID="ck_GQTDC_QDK" runat="server" AutoPostBack="true" OnCheckedChanged="ck_GQTDC_QDK_CheckedChanged" />
                                                        </div>
                                                </div>
                                            </asp:Panel>
                                        </tr>
                                    </table>
                                </div>
                            </div>


                        </td>
                    </tr>


                    <tr>
                        <td align="center" colspan="2">
                            <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                            <asp:Button ID="cmdThemmoi" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="btnThemmoi_Click" />
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                            <asp:Button ID="cmdNhapan" runat="server" CssClass="buttoninput" Text="Nhập án" OnClick="cmdNhapan_Click" />
                            <asp:Button ID="cmdTachan" runat="server" CssClass="buttoninput" Text="Tách án" OnClick="cmdTachan_Click"/>

                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="left">

                            <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="left">
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
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
                                    <asp:DropDownList ID="ddlPageCount" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
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
                                    PageSize="20" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound" >
                                    <Columns>
                                        <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
										<asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
											<HeaderTemplate>STT</HeaderTemplate>
											<ItemTemplate><%#Eval("STT")%></ItemTemplate>
										</asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Chọn</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkChon" AutoPostBack="true" ToolTip='<%#Eval("ID")%>' runat="server" />
                                                <asp:HiddenField ID="hdID" runat="server" Value='<%# Eval("ID") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
										<asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="85px">
											<HeaderTemplate>
												Chọn vụ việc
											</HeaderTemplate>
											<ItemTemplate>
												&nbsp;
												   <asp:Button ID="cmdChitiet" runat="server" Text="Chọn vụ việc" CssClass="buttonchitiet" CausesValidation="false" CommandName="Select" CommandArgument='<%#Eval("ID") %>' />
												   <div>&nbsp;</div>
												   <asp:Button ID="cmdxxlaiPT" runat="server" Text="Thụ lý lại xét xử PT"
													OnClientClick="return confirm('Bạn muốn tạo hồ sơ vụ việc do Giám đốc thẩm hủy để xét xử lại phúc thẩm?');"
													   CssClass="buttonchitiet" CausesValidation="false"
													   CommandName="xxlaiPT" CommandArgument='<%#Eval("ID") %>' />
											</ItemTemplate>
											<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
											<ItemStyle HorizontalAlign="Center"></ItemStyle>
										</asp:TemplateColumn>
										<asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
											<HeaderTemplate>
												Thông tin vụ việc
											</HeaderTemplate>
											<ItemTemplate>
												<i style='margin-right: 3px;'>Vụ việc:</i>  <b><%#Eval("TENVUVIEC")%></b>
												<br />
												<i style='margin-right: 3px;'>Cấp xét xử:</i>  <b><%#Eval("GiaiDoanVuViec")%></b>
												<%#Eval("TruongHopGiaoNhan")%>
												<%#Eval("TENTOASOTHAM")%>
												<%#Eval("BANAN_QD_ST")%>
												<%#Eval("HoTenBiCan")%>
												<%#Eval("KHANGNGHI_ST")%>
                                               
												<asp:HiddenField ID="hddCHECK_THULY" runat="server" Value='<%#Eval("CHECK_THULY")%>' />
											</ItemTemplate>
										</asp:TemplateColumn>
										<asp:BoundColumn DataField="TINHTRANG_GQ" HeaderText="Tình trạng GQ"
	                                        HeaderStyle-Width="200px" ItemStyle-HorizontalAlign="left"
	                                        HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
	                                        <HeaderTemplate>
		                                        Người tạo
	                                        </HeaderTemplate>
	                                        <ItemTemplate>
		                                        <ItemTemplate>
		                                        <%#Eval("NGUOITAO")%>
		                                        <%-- <i style="margin-right:3px;">Người tạo:</i>--%>
		                                        <br />
		                                        <%# Eval("NgayTao") %>
		                                        <%--  <i style="margin-right:3px;">Ngày tạo:</i>--%>
                                                    
	                                        </ItemTemplate>
	                                        </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
	                                        <HeaderTemplate>
		                                        Mã vụ án
	                                        </HeaderTemplate>
	                                        <ItemTemplate>
		                                        <%#Eval("MAVUVIEC")%>
	                                        </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center">
	                                        <HeaderTemplate>
		                                        Thao tác
	                                        </HeaderTemplate>
	                                        <ItemTemplate>
                                                <asp:LinkButton ID="lblview" runat="server" Text="Chi tiết" ForeColor="#0e7eee"
                                                    CausesValidation="false" CommandName="view" ToolTip='<%#Eval("ID") %>'
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                </br></br>
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" ForeColor="#0e7eee"
                                                    CausesValidation="false" CommandName="Sua"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                </br></br>
                                                <asp:LinkButton ID="lbtXoa" runat="server" ForeColor="#0e7eee" CausesValidation="false" Text="Xóa"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"
                                                    OnClientClick="return confirm('Bạn thực sự muốn xóa vụ việc này? ');"></asp:LinkButton>
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
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="true"
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
                                    <asp:DropDownList ID="ddlPageCount2" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
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
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function LoadModalDiv() {
            var bcgDiv = document.getElementById("divBackground");
            bcgDiv.style.display = "block";
            if (bcgDiv != null) {

                if (document.body.clientHeight > document.body.scrollHeight) {

                    bcgDiv.style.height = document.body.clientHeight + "px";
                }
                else {

                    bcgDiv.style.height = document.body.scrollHeight + "px";
                }
                bcgDiv.style.width = "100%";
            }
        }
        function HideModalDiv() {
            var bcgDiv = document.getElementById("divBackground");
            bcgDiv.style.display = "none";
        }
<%--        function HideModalDivNhapAn() {
            var bcgDiv = document.getElementById("divBackground");
            bcgDiv.style.display = "none";
            $("#<%= cmdLoadNhapAn.ClientID %>").click();
        }
        function HideModalDivTachAn() {
            var bcgDiv = document.getElementById("divBackground");
            bcgDiv.style.display = "none";
            $("#<%= cmdLoadTachAn.ClientID %>").click();
        }--%>
    </script>
</asp:Content>
