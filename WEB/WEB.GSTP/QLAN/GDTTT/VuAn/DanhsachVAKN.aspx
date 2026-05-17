<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" 
    CodeBehind="DanhsachVAKN.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.DanhsachVAKN" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1"%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddCountCV" Value="0" runat="server" />

    <style type="text/css">
        .DonGDTCol1 {
            width: 100px;
        }

        .DonGDTCol2 {
            width: 240px;
        }

        .DonGDTCol3 {
            width: 96px;
        }

        .DonGDTCol4 {
            width: 160px;
        }

        .DonGDTCol5 {
            width: 70px;
        }
    </style>
    <asp:HiddenField ID="hddLoaiTK" runat="server" Value="" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Tìm kiếm
                                    <asp:LinkButton ID="lbtTTTK" runat="server" Text="[ Nâng cao ]" ForeColor="#0E7EEE" OnClick="lbtTTTK_Click"></asp:LinkButton></h4>
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
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblTitleBC" runat="server" Text="Nguyên đơn"></asp:Label></td>
                                            <td>
                                                <asp:TextBox ID="txtNguyendon" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox></td>
                                            <td>
                                                <asp:Label ID="lblTitleBD" runat="server" Text="Bị đơn"></asp:Label></td>
                                            <td>
                                                <asp:TextBox ID="txtBidon" runat="server" CssClass="user" Width="152px" MaxLength="250"></asp:TextBox>
                                            </td>
                                            <td>Loại án</td>
                                            <td>
                                                <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select"
                                                    AutoPostBack="true" OnSelectedIndexChanged="ddlLoaiAn_SelectedIndexChanged"
                                                    runat="server" Width="160px">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <asp:Panel ID="pnTTTK" runat="server" Visible="false">
                                            <tr>
                                                <td>Số thụ lý</td>
                                                <td>
                                                    <asp:TextBox ID="txtThuly_So" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox></td>
                                                <td>Trạng thái hồ sơ</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlMuonHoso" runat="server"
                                                        Width="160px" CssClass="chosen-select">
                                                        <asp:ListItem Value="2" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đã có hồ sơ"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Chưa có hồ sơ"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Án thời hiệu</td>
                                                <td>
                                                    <asp:DropDownList ID="dropAnDB_TH" runat="server"
                                                        Width="160px" CssClass="chosen-select">
                                                        <asp:ListItem Value="" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Đã hết thời hiệu"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Còn thời hiệu dưới một tháng"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Còn thời hiệu dưới hai tháng"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="Còn thời hiệu dưới ba tháng"></asp:ListItem>
                                                        <asp:ListItem Value="4" Text="Còn thời hiệu dưới sáu tháng"></asp:ListItem>
                                                        <asp:ListItem Value="5" Text="Còn thời hiệu dưới 1 năm"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Cán bộ giải quyết đơn
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlThamtravien" CssClass="chosen-select" runat="server" Width="230px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>LĐ phụ trách</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlPhoVuTruong" CssClass="chosen-select"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlPhoVuTruong_SelectedIndexChanged"
                                                        runat="server" Width="160px">
                                                    </asp:DropDownList></td>
                                                <td>
                                                    <asp:DropDownList ID="ddlLoaiThamPhan" runat="server" AutoPostBack="true" OnSelectedIndexChanged="Drop_LoaiThamPhan_SelectedIndexChanged">
                                                        <asp:ListItem Text="Tất cả thẩm phán" Value="0" />
                                                        <asp:ListItem Text="Thẩm phán tối cao" Value="1" />
                                                        <asp:ListItem Text="Thẩm phán bậc 3" Value="2" />
                                                    </asp:DropDownList>
                                                <td>
                                                    <asp:DropDownList ID="ddlThamphan"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlThamphan_SelectedIndexChanged"
                                                        CssClass="chosen-select" runat="server" Width="160px">
                                                    </asp:DropDownList></td>
                                            </tr>

                                            <tr>
                                                <td>Tờ trình lãnh đạo</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlTotrinh"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlTotrinh_SelectedIndexChanged"
                                                        CssClass="chosen-select" runat="server" Width="230px">
                                                        <asp:ListItem Value="2" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Chưa có tờ trình"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đã có tờ trình"></asp:ListItem>
                                                        <asp:ListItem Value="-1" Text="Có tờ trình lần 1"></asp:ListItem>
                                                    </asp:DropDownList></td>
                                                <td>Từ ngày</td>
                                                <td>
                                                    <asp:TextBox ID="txtThuly_Tu" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtThuly_Tu" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtThuly_Tu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                                <td>Đến ngày</td>
                                                <td>
                                                    <asp:TextBox ID="txtThuly_Den" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txtThuly_Den" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txtThuly_Den" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                                <td></td>
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td>Trạng thái thụ lý</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlTrangthaithuly"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlTrangthaithuly_SelectedIndexChanged"
                                                        CssClass="chosen-select" runat="server" Width="230px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    <asp:Literal ID="lttYKienKetLuan" runat="server">Ý kiến tờ trình</asp:Literal></td>
                                                <td>
                                                    <asp:DropDownList ID="dropIsYKienKetLuatTrinhLD" Enabled="true"
                                                        CssClass="chosen-select" runat="server" Width="160px">
                                                        <asp:ListItem Value="2" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Chưa có ý kiến"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đã có ý kiến"></asp:ListItem>
                                                        <asp:ListItem Value="10" Text="... Trả lời đơn"></asp:ListItem>
                                                        <asp:ListItem Value="11" Text="... Kháng nghị"></asp:ListItem>
                                                        <asp:ListItem Value="12" Text="... Xếp đơn"></asp:ListItem>
                                                        <asp:ListItem Value="13" Text="... Xác minh, BS"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="... Yêu cầu trình tiếp"></asp:ListItem>
                                                    </asp:DropDownList></td>
                                                <td>
                                                    <asp:Literal ID="lttBuocTT" runat="server">Bước giải quyết</asp:Literal></td>
                                                <td>
                                                    <asp:DropDownList ID="dropBuocTT" Enabled="true"
                                                        CssClass="chosen-select" runat="server" Width="160px">
                                                        <asp:ListItem Value="0" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Chưa có bước giải quyết kế tiếp"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Có bước giải quyết kế tiếp"></asp:ListItem>
                                                    </asp:DropDownList></td>
                                            </tr>
                                            <tr>
                                                <td>Yêu cầu trình tiếp</td>
                                                <td>
                                                    <asp:DropDownList ID="dropCapTrinhTiepTheo" Enabled="true"
                                                        CssClass="chosen-select" runat="server" Width="230px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Đăng ký ngày báo cáo</td>
                                                <td>
                                                    <asp:DropDownList ID="dropDangKyBC" Enabled="true"
                                                        CssClass="chosen-select" runat="server" Width="160px">
                                                        <asp:ListItem Value="2" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Hoãn THA ?</td>
                                                <td>
                                                    <asp:DropDownList ID="dropHoanTHA" runat="server"
                                                        Width="160px" CssClass="chosen-select">
                                                        <asp:ListItem Value="2" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Thuộc án</td>
                                                <td>
                                                    <asp:DropDownList ID="dropAnDB"
                                                        AutoPostBack="true" OnSelectedIndexChanged="dropAnDB_SelectedIndexChanged"
                                                        CssClass="chosen-select" runat="server" Width="230px">
                                                        <asp:ListItem Value="0" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Án Quốc hội"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Án Chỉ đạo"></asp:ListItem>
                                                        <asp:ListItem Value="4" Text="Án trao đổi CV"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlLOAICVPC" runat="server" Width="80px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtCV_So" runat="server" AutoPostBack="true" OnTextChanged="txtCV_So_OnChanged" CssClass="user" Width="152px" MaxLength="250"></asp:TextBox>
                                                </td>
                                                <td id="txtNgayCV" runat="server">Ngày công văn</td>
                                                <td>
                                                    <asp:TextBox ID="txtCV_Ngay" runat="server" AutoPostBack="true" OnTextChanged="txtCV_So_OnChanged" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtCV_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtCV_Ngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                            </tr>                                            
                                            <tr>
                                                <td>Trạng thái chuyển</td>
                                                <td>
                                                    <asp:DropDownList ID="dropTrangThaiChuyen" CssClass="chosen-select" runat="server" Width="230px"
                                                        AutoPostBack="true" OnSelectedIndexChanged="dropTrangThaiChuyen_SelectedIndexChanged">
                                                        <asp:ListItem Value="0" Text="Chưa chuyển"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đã chuyển"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                        </asp:Panel>

                                        <tr>
                                            <td></td>
                                            <td align="left" colspan="3">
                                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput"
                                                    Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                                                <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <%--<tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">In báo cáo
                                    <asp:LinkButton ID="lkInBC_OpenForm" runat="server" Text="[ Mở ]"
                                        ForeColor="#0E7EEE" OnClick="lkInBC_OpenForm_Click"></asp:LinkButton></h4>
                                <div class="boder" style="padding: 10px;">
                                    <asp:Panel ID="pnInBC" runat="server" Visible="false">
                                        <table class="table1">
                                            <tr>
                                                <td class="DonGDTCol1">Tiêu đề báo cáo</td>
                                                <td>
                                                    <asp:TextBox ID="txtTieuDeBC" runat="server"
                                                        CssClass="user" Width="486px" MaxLength="250" Text="Danh sách các vụ án"></asp:TextBox>
                                                    <asp:Button ID="cmdPrint" runat="server" CssClass="buttoninput" Text="In danh sách" OnClick="cmdPrint_Click" />
                                                    <asp:Button ID="cmdPrintBC" runat="server" CssClass="buttoninput" Text="In Báo cáo" OnClick="cmdPrintBC_Click" />
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                </div>
                            </div>
                        </td>
                    </tr>--%>
                    <%--------------------------------------------------------------------%>
                    <tr>
                        <td colspan="6">
                            <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Chuyển vụ án, Thu hồi
                                    <asp:LinkButton ID="lbtTTBC" runat="server" Text="[ Mở ]" ForeColor="#0E7EEE" OnClick="lbtTTBC_Click"></asp:LinkButton></h4>
                                <div class="boder" style="padding: 10px;">
                                    <asp:Panel ID="pnTTBC" runat="server" Visible="false">
                                        <table class="table1">
                                            <tr>
                                                <td style="width: 170px;">
                                                    <%--Số công văn gửi--%>
                                                    <asp:DropDownList ID="ddlLoaiso" runat="server" Width="170px" Height="28px"
                                                        AutoPostBack="true" OnSelectedIndexChanged="Drop_LoaiSo_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="width: 110px;">
                                                    <asp:TextBox ID="txtBC_SoCV" runat="server" CssClass="user" onkeypress="return isNumber(event)" Width="102px" MaxLength="5"></asp:TextBox>
                                                </td>
                                                <td style="width: 120px;">Ngày dự kiến chuyển</td>
                                                <td style="width: 120px;">
                                                    <asp:TextBox ID="txtBC_Ngaydk" runat="server"
                                                        AutoPostBack="true"
                                                        CssClass="user" Width="112px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtBC_Ngaydk" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtBC_Ngaydk" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                                <td style="width: 60px;">Người ký</td>
                                                <td style="" colspan="3">
                                                    <asp:DropDownList ID="ddlNguoiKy" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                </td>
                                                <td colspan="2">
                                                    <div style="float: right">
                                                        <asp:Button ID="btnLuuVBchuyen" runat="server" CssClass="buttoninput" Text="Lưu Số Văn bản" OnClick="btnLuuVB_Click" Width="119px" Enabled="false" />
                                                        <asp:Button ID="btnQuanlyVB" runat="server" CssClass="buttoninput" Text="Quản lý Sổ VB" OnClick="btnQuanlyVB_Click" Width="119px" />
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="8">
                                                    <asp:Button ID="btnNBInPVAKN" runat="server" Width="200px" CssClass="buttonprint" Text="Phiếu chuyển vụ án kháng nghị" OnClick="btnNBInPVAKN_Click" Visible="false" />
                                                    <asp:Button ID="btnNBInDSVAKN" runat="server" Width="200px" CssClass="buttonprint" Text="Danh sách vụ án kháng nghị" OnClick="cmdPrint_Click" Visible="false"  />
                                                </td>
                                                <td align="right" style="vertical-align: top;">
                                                    <asp:Button ID="btnChuyenVuAn" runat="server" CssClass="buttoninput" Text="Chuyển vụ án" OnClientClick="return confirm('Bạn chắc chắn muốn chuyển vụ án?');" OnClick="btnChuyenVuAn_Click" Width="119px" />
                                                    <asp:Button ID="btnThuHoi" runat="server" OnClientClick="return confirm('Bạn chắc chắn muốn thu hồi vụ án chưa nhận?');" CssClass="buttoninput" Text="Thu hồi" OnClick="btnThuHoi_Click" Width="119px" />
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
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
                                                <asp:CheckBox ID="chkChon" ToolTip='<%#Eval("arrDonID")%>' runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="STT" HeaderText="TT" HeaderStyle-Width="30px" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Số & Ngày thụ lý
                                        </HeaderTemplate>
                                        <ItemTemplate>

                                            <%#(Eval("LisThuLyDon")+"").Replace(";", ", <br/>")%>

                                            <br style="margin-top: 10px;" />
                                            <asp:LinkButton ID="cmdSoDonTrung" runat="server" ForeColor="#0e7eee" Font-Bold="true"
                                                CommandArgument='<%#Eval("arrDONID") %>' CommandName="SoDonTrung"
                                                Text='<%# "Số đơn " + Eval("TONGDON")  + "<br/> (" + Eval("cThulymoi")+ " đơn TLM)"  %>'></asp:LinkButton>

                                            <br />
                                            <asp:LinkButton ID="cmdCV81" runat="server" Font-Size="12px" ForeColor="#0e7eee" Font-Bold="true"
                                                CommandArgument='<%#Eval("arrCV81ID") %>' CommandName="CongVan81" Text='<%# "Án Quốc hội"  %>'
                                                Visible='<%# (Eval("SoCV81")+"")=="0"?false:true  %>'></asp:LinkButton>

                                            <br />
                                            <asp:LinkButton ID="cmdChidao" runat="server" Font-Size="12px" ForeColor="#0e7eee" Font-Bold="true"
                                                CommandArgument='<%#Eval("arrCHIDAOID") %>' CommandName="CHIDAO"
                                                Visible='<%# (Eval("IsAnChiDao")+"")=="0"?false:true  %>' Text='<%# "Án chỉ đạo"  %>'></asp:LinkButton>

                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thông tin bản án</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("InforBA")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="QHPLDN" HeaderText="Quan hệ pháp luật" HeaderStyle-Width="60px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGUYENDON" HeaderText="Nguyên đơn/ Người khởi kiện" HeaderStyle-Width="70px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="BIDON" HeaderText="Bị đơn/ Người bị kiện" HeaderStyle-Width="70px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGUOIKHIEUNAI" HeaderText="Người đề nghị" HeaderStyle-Width="90px"></asp:BoundColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="150px" ItemStyle-HorizontalAlign="Justify" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Thẩm tra viên<br />
                                            Lãnh đạo Vụ<br />
                                            Thẩm phán
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Literal ID="lttTTV" runat="server"></asp:Literal>
                                            <br />
                                            <%# String.IsNullOrEmpty(Eval("TENLANHDAO")+"")? "":( Eval("MaChucVuLD") + ":<b style='margin-left:3px;'>"+Eval("TENLANHDAO")+"</b><br />")%>
                                            <%# String.IsNullOrEmpty(Eval("TENTHAMPHAN")+"")? "":("TP:<b style='margin-left:3px;'>"+Eval("TENTHAMPHAN")+"</b><br/>")%>
                                            <%# String.IsNullOrEmpty(Eval("THAMPHANTC_TEN")+"")? "":("TPTC:<b style='margin-left:3px;'>"+Eval("THAMPHANTC_TEN")+"</b><br/>")%>     
                                            <%# String.IsNullOrEmpty(Eval("ghichu")+"")? "":("<i style='margin-left:3px;font-size: 8pt;'>Ghi chú: "+Eval("ghichu")+"</i>")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thông tin trình</HeaderTemplate>
                                        <ItemTemplate>
                                            <b>
                                                <asp:Literal ID="lttLanTT" runat="server"></asp:Literal></b>
                                            <br />
                                            <asp:Literal ID="lttDetaiTinhTrang" runat="server"></asp:Literal>
                                            <br />
                                            <asp:Literal ID="lttYKien" runat="server"></asp:Literal>
                                            <asp:Literal ID="lttKQGQ" runat="server"></asp:Literal>
                                            <asp:Literal ID="lttOther" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                                                        
                                    <asp:TemplateColumn HeaderStyle-Width="250px" ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thông tin chuyển/nhận</HeaderTemplate>
                                        <ItemTemplate>
                                            <b>Số CV: <%#Eval("SOVB")%></b>
                                            <br />
                                            <b>Ngày CV: <%#Eval("NGAYVB")%></b>
                                            <br />
                                            <br />
                                            Trạng thái chuyển: <%#Eval("trang_thai_chuyen")%>
                                            <br />
                                            Ngày chuyển: <%#Eval("NGAYCHUYEN")%>
                                            <br />
                                            Người chuyển: <%#Eval("NGUOICHUYEN")%>
                                            <br />
                                            <br />
                                            Trạng thái nhận: <%#Eval("trang_thai_nhan")%>
                                            <br />
                                            Ngày nhận: <%#Eval("NGAYNHAN")%>
                                            <br />
                                            Người nhận: <%#Eval("NGUOINHAN")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thao tác</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:ImageButton ID="cmdPrinDS" runat="server" ToolTip="In DS tờ trình" CssClass="grid_button"
                                                CommandArgument='<%#Eval("ID") %>' CommandName="TOTRINH" ImageUrl="~/UI/img/printer-16.png" Width="18px"/>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                            <asp:DataGrid ID="gridHS" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%"
                                OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                <Columns>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="STT" HeaderText="TT" HeaderStyle-Width="30px" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Số & Ngày thụ lý
                                        </HeaderTemplate>
                                        <ItemTemplate>

                                            <%#(Eval("LisThuLyDon")+"").Replace(";", ", <br/>")%>

                                            <br style="margin-top: 10px;" />
                                            <asp:LinkButton ID="cmdSoDonTrung" runat="server" ForeColor="#0e7eee" Font-Bold="true"
                                                CommandArgument='<%#Eval("arrDONID") %>' CommandName="SoDonTrung"
                                                Text='<%# "Số đơn " + Eval("TONGDON")  %>'></asp:LinkButton>

                                            <br />
                                            <asp:LinkButton ID="cmdCV81" runat="server" Font-Size="12px" ForeColor="#0e7eee" Font-Bold="true"
                                                CommandArgument='<%#Eval("arrCV81ID") %>' CommandName="CongVan81" Text='<%# "Án Quốc hội"  %>'
                                                Visible='<%# (Eval("SoCV81")+"")=="0"?false:true  %>'></asp:LinkButton>

                                            <br />
                                            <asp:LinkButton ID="cmdChidao" runat="server" Font-Size="12px" ForeColor="#0e7eee" Font-Bold="true"
                                                CommandArgument='<%#Eval("arrCHIDAOID") %>' CommandName="CHIDAO"
                                                Visible='<%# (Eval("IsAnChiDao")+"")=="0"?false:true  %>' Text='<%# "Án chỉ đạo"  %>'></asp:LinkButton>

                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thông tin bản án</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("InforBA")%>
                                            <%--<b><%#Eval("SOANPHUCTHAM")%></b>
                                            <br />
                                            <%#Eval("NGAYXUPHUCTHAM")%>
                                            <br />
                                            <%#Eval("TOAXX_VietTat")%>--%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="QHPLDN" HeaderText="Tội danh" HeaderStyle-Width="120px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGUYENDON" HeaderText="Bị cáo đầu vụ" HeaderStyle-Width="70px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="BIDON" HeaderText="Bị cáo khiếu nại" HeaderStyle-Width="70px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGUOIKHIEUNAI" HeaderText="Người đề nghị" HeaderStyle-Width="90px"></asp:BoundColumn>


                                    <asp:TemplateColumn HeaderStyle-Width="150px" ItemStyle-HorizontalAlign="Justify" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Thẩm tra viên<br />
                                            Lãnh đạo Vụ<br />
                                            Thẩm phán
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Literal ID="lttTTV" runat="server"></asp:Literal>
                                            <br />
                                            <%# String.IsNullOrEmpty(Eval("TENLANHDAO")+"")? "":( Eval("MaChucVuLD") + ":<b style='margin-left:3px;'>"+Eval("TENLANHDAO")+"</b><br />")%>
                                            <%# String.IsNullOrEmpty(Eval("TENTHAMPHAN")+"")? "":("TP:<b style='margin-left:3px;'>"+Eval("TENTHAMPHAN")+"</b><br />")%>
                                            <%# String.IsNullOrEmpty(Eval("THAMPHANTC_TEN")+"")? "":("TPTC:<b style='margin-left:3px;'>"+Eval("THAMPHANTC_TEN")+"</b>")%>                                            
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Trạng thái</HeaderTemplate>
                                        <ItemTemplate>
                                            <b>
                                                <asp:Literal ID="lttLanTT" runat="server"></asp:Literal></b>
                                            <br />
                                            <asp:Literal ID="lttDetaiTinhTrang" runat="server"></asp:Literal>
                                            <asp:Literal ID="lttKQGQ" runat="server"></asp:Literal>
                                            <asp:Literal ID="lttOther" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thao tác</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="cmdTotrinh" runat="server" Font-Bold="true"
                                                ForeColor="#0e7eee" Text="Quản lý tờ trình"
                                                CommandArgument='<%#Eval("ID") %>' CommandName="TOTRINH"></asp:LinkButton>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
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
    </div>

    <script type="text/javascript">
        function PopupReport(pageURL, title, w, h) {
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }
        function LoadDsDon() {
            $("#<%= cmdTimkiem.ClientID %>").click();
        }
        
    </script>

    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
                
        function Confirm() {
            var id = "confirm_value",
                confirm_value = document.getElementById("confirm_value");
            if (!confirm_value) {
                confirm_value = document.createElement("input");
                confirm_value.type = "hidden";
                confirm_value.name = id;
                confirm_value.id = id;
                document.forms[0].appendChild(confirm_value);
            }
            var HddCount = document.getElementById('<%= hddCountCV.ClientID %>');
            var txtBC_SoCV = document.getElementById('<%=txtBC_SoCV.ClientID%>');
            if (txtBC_SoCV.value != "" & HddCount.value == "1") {
                confirm_value.value = confirm("Một số đơn đã có số Công văn nên không được ghi đè!\n" +
                    "Các đơn chưa có số Công văn bạn có muốn chèn số Công văn cho các đơn này không? ") ? "yes" : "no";

                return true;
            } else {
                confirm_value.value = 'yes';
                return true;
            }

        }
    </script>
</asp:Content>

