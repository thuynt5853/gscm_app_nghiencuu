<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Bienbankiemphieu.aspx.cs" Inherits="WEB.GSTP.TDKT.HoSo.Bienbankiemphieu" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../UI/js/Common.js"></script>
    <style type="text/css">
        .msg_error {
            text-align: left !important;
        }

        .box {
            padding-bottom: 0px !important;
        }

        .HoSo_BienBan_Col1 {
            width: 132px;
        }

        .HoSo_BienBan_Col2 {
            width: 128px;
        }

        .HoSo_BienBan_Col3 {
            width: 95px;
        }

        .HoSo_BienBan_Load_Left {
            float: left;
        }

        .truong {
            min-height: 375px !important;
        }

        .table2 .header {
            text-align: center;
        }
    </style>
    <asp:HiddenField ID="HdfVuTDKT" Value="0" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td><b>Biên bản kiểm phiếu về việc<span style="color: red;"> (*)</span></b></td>
                        <td colspan="3">
                            <asp:TextBox ID="TxtVeViec" runat="server" CssClass="user" Width="425px" MaxLength="500"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td><b>Số cá nhân đăng ký</b></td>
                        <td>
                            <asp:TextBox runat="server" ID="TxtTong_Ca_Nhan_DK" Width="100px" CssClass="user align_right" MaxLength="4" onkeypress="return isNumber(event)"></asp:TextBox>
                        </td>
                        <td><b>Có mặt</b></td>
                        <td>
                            <asp:TextBox ID="TxtCa_Nhan_Co_Mat" runat="server" Width="55px" CssClass="HoSo_BienBan_Load_Left user align_right" MaxLength="4" onkeypress="return isNumber(event)"></asp:TextBox>
                            <span style="font-weight: bold; width: 60px; float: left; margin-left: 10px; margin-top: 6px;">vắng mặt</span>
                            <asp:TextBox runat="server" ID="TxtCa_Nhan_Vang_Mat" Width="55px" CssClass="HoSo_BienBan_Load_Left user align_right" MaxLength="2" onkeypress="return isNumber(event)"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="HoSo_BienBan_Col1"><b>Thời gian<span style="color: red;"> (*)</span></b></td>
                        <td class="HoSo_BienBan_Col2">
                            <asp:TextBox ID="TxtNgay" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="TxtNgay" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="TxtNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                        <td class="HoSo_BienBan_Col3"><b>Thành viên ban kiểm phiếu</b></td>
                        <td>
                            <asp:DropDownList ID="DropSoThanhVien" Width="197px" runat="server" CssClass="chosen-select" AutoPostBack="true" OnSelectedIndexChanged="DropSoThanhVien_SelectedIndexChanged"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Danh sách thành viên ban kiểm phiếu</b></td>
                        <td colspan="3">
                            <table class="table2" style="width: 434px;">
                                <tr class="header">
                                    <td style="width: 19px;">Thứ tự</td>
                                    <td>Họ tên</td>
                                    <td style="width: 111px;">Chức vụ</td>
                                </tr>
                                <tr id="row_1" runat="server">
                                    <td style="text-align: center;">1</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_1" runat="server" Value="1" />
                                        <asp:TextBox ID="txtHoTen_1" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropVaiTro_1" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Trưởng ban" Value="Trưởng ban"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_2" runat="server">
                                    <td style="text-align: center;">2</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_2" runat="server" Value="2" />
                                        <asp:TextBox ID="txtHoTen_2" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropVaiTro_2" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Trưởng ban" Value="Trưởng ban"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_3" runat="server">
                                    <td style="text-align: center;">3</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_3" runat="server" Value="3" />
                                        <asp:TextBox ID="txtHoTen_3" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropVaiTro_3" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Trưởng ban" Value="Trưởng ban"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_4" runat="server">
                                    <td style="text-align: center;">4</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_4" runat="server" Value="4" />
                                        <asp:TextBox ID="txtHoTen_4" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropVaiTro_4" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Trưởng ban" Value="Trưởng ban"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_5" runat="server">
                                    <td style="text-align: center;">5</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_5" runat="server" Value="5" />
                                        <asp:TextBox ID="txtHoTen_5" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropVaiTro_5" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Trưởng ban" Value="Trưởng ban"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_6" runat="server">
                                    <td style="text-align: center;">6</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_6" runat="server" Value="6" />
                                        <asp:TextBox ID="txtHoTen_6" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropVaiTro_6" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Trưởng ban" Value="Trưởng ban"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_7" runat="server">
                                    <td style="text-align: center;">7</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_7" runat="server" Value="7" />
                                        <asp:TextBox ID="txtHoTen_7" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropVaiTro_7" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Trưởng ban" Value="Trưởng ban"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_8" runat="server">
                                    <td style="text-align: center;">8</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_8" runat="server" Value="8" />
                                        <asp:TextBox ID="txtHoTen_8" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropVaiTro_8" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Trưởng ban" Value="Trưởng ban"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_9" runat="server">
                                    <td style="text-align: center;">9</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_9" runat="server" Value="9" />
                                        <asp:TextBox ID="txtHoTen_9" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropVaiTro_9" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Trưởng ban" Value="Trưởng ban"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_10" runat="server">
                                    <td style="text-align: center;">10</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_10" runat="server" Value="10" />
                                        <asp:TextBox ID="txtHoTen_10" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropVaiTro_10" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Trưởng ban" Value="Trưởng ban"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_11" runat="server">
                                    <td style="text-align: center;">11</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_11" runat="server" Value="11" />
                                        <asp:TextBox ID="txtHoTen_11" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropVaiTro_11" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Trưởng ban" Value="Trưởng ban"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_12" runat="server">
                                    <td style="text-align: center;">12</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_12" runat="server" Value="12" />
                                        <asp:TextBox ID="txtHoTen_12" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropVaiTro_12" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Trưởng ban" Value="Trưởng ban"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_13" runat="server">
                                    <td style="text-align: center;">13</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_13" runat="server" Value="13" />
                                        <asp:TextBox ID="txtHoTen_13" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropVaiTro_13" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Trưởng ban" Value="Trưởng ban"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_14" runat="server">
                                    <td style="text-align: center;">14</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_14" runat="server" Value="14" />
                                        <asp:TextBox ID="txtHoTen_14" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropVaiTro_14" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Trưởng ban" Value="Trưởng ban"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_15" runat="server">
                                    <td style="text-align: center;">15</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_15" runat="server" Value="15" />
                                        <asp:TextBox ID="txtHoTen_15" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropVaiTro_15" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Trưởng ban" Value="Trưởng ban"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_16" runat="server">
                                    <td style="text-align: center;">16</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_16" runat="server" Value="16" />
                                        <asp:TextBox ID="txtHoTen_16" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropVaiTro_16" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Trưởng ban" Value="Trưởng ban"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_17" runat="server">
                                    <td style="text-align: center;">17</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_17" runat="server" Value="17" />
                                        <asp:TextBox ID="txtHoTen_17" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropVaiTro_17" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Trưởng ban" Value="Trưởng ban"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_18" runat="server">
                                    <td style="text-align: center;">18</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_18" runat="server" Value="18" />
                                        <asp:TextBox ID="txtHoTen_18" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropVaiTro_18" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Trưởng ban" Value="Trưởng ban"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_19" runat="server">
                                    <td style="text-align: center;">19</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_19" runat="server" Value="19" />
                                        <asp:TextBox ID="txtHoTen_19" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropVaiTro_19" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Trưởng ban" Value="Trưởng ban"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_20" runat="server">
                                    <td style="text-align: center;">20</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_20" runat="server" Value="20" />
                                        <asp:TextBox ID="txtHoTen_20" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropVaiTro_20" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Trưởng ban" Value="Trưởng ban"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <div class="boxchung">
                                <h4 class="tleboxchung bg_title_group">Kết quả bình xét</h4>
                                <div class="boder" style="padding: 5px 10px;">
                                    <table class="table1">
                                        <tr>
                                            <td>
                                                <table class="table1">
                                                    <tr>
                                                        <td style="width:110px;"><b>Số phiếu phát ra</b></td>
                                                        <td class="HoSo_BienBan_Col2">
                                                            <asp:TextBox ID="TxtSoPhieu_Phat_Ra" runat="server" Width="100px" CssClass="HoSo_BienBan_Load_Left user align_right" MaxLength="4" onkeypress="return isNumber(event)"></asp:TextBox>
                                                        </td>
                                                        <td class="HoSo_BienBan_Col3"><b>Số phiếu thu về</b></td>
                                                        <td>
                                                            <asp:TextBox ID="TxtSoPhieu_Thu_Ve" runat="server" Width="100px" CssClass="HoSo_BienBan_Load_Left user align_right" MaxLength="4" onkeypress="return isNumber(event)"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><b>Số phiếu thu về hợp lệ</b></td>
                                                        <td>
                                                            <asp:TextBox ID="TxtSoPhieu_Thu_Ve_Hop_Le" runat="server" Width="100px" CssClass="HoSo_BienBan_Load_Left user align_right" MaxLength="4" onkeypress="return isNumber(event)"></asp:TextBox>
                                                        </td>
                                                        <td><b>Số phiếu thu về không hợp lệ</b></td>
                                                        <td>
                                                            <asp:TextBox ID="TxtSoPhieu_Thu_Ve_Khong_Hop_Le" runat="server" Width="100px" CssClass="HoSo_BienBan_Load_Left user align_right" MaxLength="4" onkeypress="return isNumber(event)"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4">
                                                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                                AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                                                ItemStyle-CssClass="chan" Width="100%" OnItemDataBound="dgList_ItemDataBound">
                                                                <Columns>
                                                                    <asp:BoundColumn DataField="DOI_TUONG_ID" Visible="false"></asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="STT" HeaderText="Thứ tự" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="40px"></asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="TENDOITUONG" HeaderText="Tên đối tượng" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="LOAIDOITUONG" HeaderText="Loại đối tượng" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="88px"></asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="HINHTHUC" HeaderText="Hình thức" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="200px"></asp:BoundColumn>
                                                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="126px" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="126px">
                                                                        <HeaderTemplate>Số phiếu bình xét</HeaderTemplate>
                                                                        <ItemTemplate>
                                                                            <asp:TextBox ID="TxtSoPhieu_Binh_Xet" runat="server" Width="94%" CssClass="user align_right" MaxLength="4" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateColumn>
                                                                </Columns>
                                                            </asp:DataGrid>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="3">
                            <asp:Button ID="BtnLuu" runat="server" CssClass="buttoninput" Text="Lưu" OnClientClick="return Validate();" OnClick="BtnLuu_Click" />
                            <asp:Button ID="BtnXoa" runat="server" CssClass="buttoninput" Visible="false" Text="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa biên bản này? ');" OnClick="BtnXoa_Click" />
                            <asp:Button ID="BtnQuayLai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="BtnQuayLai_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="3">
                            <asp:Label runat="server" ID="Lblthongbao" Style="color: red;"></asp:Label></td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            $(function () {

                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            });
        }
        function Validate() {
        }
    </script>
</asp:Content>
