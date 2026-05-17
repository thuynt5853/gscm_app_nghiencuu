<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true"
    CodeBehind="ChiTietVB_DangKy.aspx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.ChiTietVB_DangKy" %>

<%@ Register Src="~/Personnal/UC/DsFileDonKK.ascx" TagPrefix="uc1" TagName="DsFileDonKK" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .content_item_row {
            float: left;
            font-weight: bold;
            width: 100%;
        }

        #tblDetail tr td {
            background: white;
            padding: 10px 7px;
        }
    </style>

    <asp:Literal ID="lttThongBao" runat="server"></asp:Literal>
    <div>
        <table style="background: #f5f5f5; width: 100%;" cellpadding="1" id="tblDetail">
            <tr>
                <td style="width: 115px;" class="background_gray">Vụ việc</td>
                <td colspan="3">
                    <asp:Literal ID="lttVuViec" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td style="width: 115px;" class="background_gray">Thông tin thụ lý</td>
                <td colspan="3">
                    <asp:Literal ID="lttToaAn" runat="server"></asp:Literal>
                </td>
            </tr>
            <!------------------nguyen don -------------------->
            <tr>
                <td colspan="4" class="background_gray" style="font-weight: bold;">1. Người khởi kiện</td>
            </tr>
            <tr>
                <td class="background_gray">Người khởi kiện</td>
                <td style="width: 250px;">
                    <asp:Label ID="lblTennguyendon"
                        runat="server" Width="94%"></asp:Label></td>

                <td style="width: 80px;" class="background_gray">Ngày sinh</td>
                <td>
                    <asp:Label ID="lblNguyendon_ngaysinh"
                        runat="server" Width="94%"></asp:Label></td>
            </tr>
            <tr>
                <td class="background_gray">Số CMND/ Thẻ căn cước/ Hộ chiếu</td>
                <td>
                    <asp:Label ID="lblCMND" runat="server"
                        Width="80%" MaxLength="250"></asp:Label></td>
                <td class="background_gray">Quốc tịch</td>
                <td>
                    <asp:Label ID="lblQuocTich" runat="server"
                        Width="80%" MaxLength="250"></asp:Label></td>
            </tr>
            <tr>
                <td class="background_gray">Điện thoại</td>
                <td>
                    <asp:Label ID="lblDienThoai" runat="server"
                        Width="80%" MaxLength="250"></asp:Label></td>
                <td class="background_gray">Fax</td>
                <td>
                    <asp:Label ID="lblFax" runat="server"
                        Width="80%" MaxLength="250"></asp:Label></td>
            </tr>
            <tr>
                <td class="background_gray">Email</td>
                <td colspan="3">
                    <asp:Label ID="lblEmail" runat="server"
                        Width="80%" MaxLength="250"></asp:Label></td>

            </tr>
            <asp:Panel ID="pnNguyenDonKhac" runat="server">
                <tr>
                    <td colspan="4" class="background_gray">
                        <b>Danh sách người khởi kiện khác</b></td>
                </tr>
                <tr>
                    <td colspan="4" style="background: #fff;">
                        <asp:Repeater ID="rptNguyenDon" runat="server">
                            <HeaderTemplate>
                                <div class="CSSTableGenerator">
                                    <table>
                                        <tr id="row_header">
                                            <td style="width: 20px;">TT</td>
                                            <td>Họ và tên</td>
                                            <td style="width: 50px;">Năm sinh</td>
                                            <td style="width: 50px;">CMND</td>
                                            <td style="width: 100px;">Địa chỉ</td>
                                        </tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td><%# Container.ItemIndex + 1 %></td>
                                    <td>
                                        <div style="text-align: justify; float: left;"><%#Eval("TENDUONGSU") %></div>
                                    </td>
                                    <td><%#Eval("NAMSINH") %></td>
                                    <td><%#Eval("SoCMND") %></td>
                                    <td><%#Eval("DIACHIDS") %></td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate></table></div></FooterTemplate>
                        </asp:Repeater>
                    </td>
                </tr>
            </asp:Panel>
            <!----------Bi don------------------------------->
            <tr>
                <td colspan="4" style="font-weight: bold;" class="background_gray">2. Người bị kiện</td>
            </tr>
            <tr>
                <td class="background_gray">Người bị kiện</td>
                <td>
                    <asp:Label ID="lblTenbidon"
                        runat="server" Width="94%"></asp:Label></td>

                <td class="background_gray">Ngày sinh</td>
                <td>
                    <asp:Label ID="lblbidon_ngaysinh"
                        runat="server" Width="94%"></asp:Label></td>
            </tr>
            <tr>
                <td class="background_gray">Số CMND/ Thẻ căn cước/ Hộ chiếu</td>
                <td>
                    <asp:Label ID="lblbidonCMND" runat="server"
                        Width="80%" MaxLength="250"></asp:Label></td>
                <td class="background_gray">Quốc tịch</td>
                <td>
                    <asp:Label ID="lblbidonQuocTich" runat="server"
                        Width="80%" MaxLength="250"></asp:Label></td>
            </tr>
            <tr>
                <td class="background_gray">Điện thoại</td>
                <td>
                    <asp:Label ID="lblbidonDienThoai" runat="server"
                        Width="80%" MaxLength="250"></asp:Label></td>
                <td class="background_gray">Fax</td>
                <td>
                    <asp:Label ID="lblbidonFax" runat="server"
                        Width="80%" MaxLength="250"></asp:Label></td>
            </tr>
            <tr>
                <td class="background_gray">Email</td>
                <td colspan="3">
                    <asp:Label ID="lblbidonEmail" runat="server"
                        Width="80%" MaxLength="250"></asp:Label></td>

            </tr>
            <asp:Panel ID="pnBiDonKhac" runat="server">
                <tr>
                    <td colspan="4" class="background_gray">
                        <b>Danh sách người bị kiện khác</b></td>
                </tr>
                <tr>
                    <td colspan="4" style="background: #fff;">
                        <asp:Repeater ID="rptBiDon" runat="server">
                            <HeaderTemplate>
                                <div class="CSSTableGenerator">
                                    <table>

                                        <tr id="row_header">
                                            <td style="width: 20px;">TT</td>
                                            <td>Họ và tên</td>
                                            <td style="width: 50px;">Năm sinh</td>
                                            <td style="width: 50px;">CMND</td>
                                            <td style="width: 100px;">Địa chỉ</td>
                                        </tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td><%# Container.ItemIndex + 1 %></td>
                                    <td>
                                        <div style="text-align: justify; float: left;"><%#Eval("TENDUONGSU") %></div>
                                    </td>
                                    <td><%#Eval("NAMSINH") %></td>
                                    <td><%#Eval("SoCMND") %></td>
                                    <td><%#Eval("DIACHIDS") %></td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate></table></div></FooterTemplate>
                        </asp:Repeater>

                    </td>
                </tr>
            </asp:Panel>
            <!------------Duong su khac----------------------------->
            <asp:Panel ID="pnDSKhac" runat="server">
                <tr>
                    <td colspan="4" style="font-weight: bold;" class="background_gray">3. Danh sách đương sự khác</td>
                </tr>
                <tr>
                    <td colspan="4" style="background: white;">
                        <asp:Repeater ID="rptDuongSuKhac" runat="server">
                            <HeaderTemplate>
                                <div class="CSSTableGenerator">
                                    <table>
                                        <tr id="row_header">
                                            <td style="width: 20px;">TT</td>
                                            <td>Họ và tên</td>
                                            <td style="width: 100px;">Tư cách tố tụng</td>
                                            <td style="width: 50px;">Năm sinh</td>
                                            <td style="width: 50px;">CMND</td>
                                            <td style="width: 100px;">Địa chỉ</td>
                                        </tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td><%# Container.ItemIndex + 1 %></td>
                                    <td><%#Eval("TENDUONGSU") %></td>
                                    <td><%#Eval("TENTCTT") %></td>
                                    <td><%#Eval("NAMSINH") %></td>
                                    <td><%#Eval("SoCMND") %></td>
                                    <td><%#Eval("DIACHIDS") %></td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate></table></div></FooterTemplate>
                        </asp:Repeater>
                    </td>
                </tr>
            </asp:Panel>
            <!----------------------------------------->

        </table>
    </div>

    <uc1:DsFileDonKK runat="server" ID="DsFileDonKK" />

    <asp:Panel ID="pnVBTongDat" runat="server">
        <div style="float: left; width: 100%; text-transform: uppercase; font-weight: bold; margin-top: 10px; margin-bottom: 5px;">Danh sách văn bản, thông báo mới của Tòa án</div>

        <asp:Repeater ID="rptFile" runat="server"
            OnItemCommand="rptFile_ItemCommand"
            OnItemDataBound="rptFile_ItemDataBound">
            <HeaderTemplate>
                <div class="CSSTableGenerator">
                    <table>

                        <tr id="row_header">
                            <td style="width: 20px;">TT</td>
                            <td>Tên văn bản</td>
                            <td style="width: 70px;">Ngày gửi</td>
                            <td style="width: 100px;">Ngày tiếp nhận</td>
                            <td style="width: 75px;">Tệp đính kèm</td>
                        </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><%# Container.ItemIndex + 1 %></td>
                    <td>
                        <asp:LinkButton ID="lkVB" runat="server" Text='<%#Eval("TenVanBan") %>'
                            CommandArgument='<%#Eval("ID") %>' CommandName="view"></asp:LinkButton>
                    </td>
                    <td><%# string.Format("{0:dd/MM/yyyy hh:mm tt}",Eval("NgayGui")) %>
                    </td>
                    <td><%# string.Format("{0:dd/MM/yyyy hh:mm tt}",Eval("NgayDoc")) %></td>
                    <td>
                        <div class="align_center">
                            <asp:ImageButton ID="imgFile" runat="server"
                                CommandArgument='<%#Eval("ID") %>' CommandName="dowload" />
                        </div>
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
</div>
            </FooterTemplate>
        </asp:Repeater>
    </asp:Panel>


</asp:Content>
