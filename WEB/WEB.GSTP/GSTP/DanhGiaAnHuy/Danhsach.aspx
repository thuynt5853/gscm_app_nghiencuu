<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.GSTP.DanhGiaAnHuy.Danhsach" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style type="text/css">
        .table2 td a {
            color: #333333;
            text-decoration: none;
        }

            .table2 td a:hover {
                text-decoration: underline;
            }
    </style>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="20" runat="server" />
    <div class="box" style="float: left; width: 99.5%;">
        <div class="box_nd" style="float: left; width: 99%;">
            <div class="truong" style="float: left; width: 99%;">
                <div style="margin-left: 10px;">
                    <span style="font-weight: bold; text-transform: uppercase;">Thông tin các đánh giá của thẩm phán, Ủy ban thẩm phán về án hủy</span>
                    <div style="float: left; width: 100%; margin: 5px 0px">
                        <asp:Label runat="server" ID="lbthongbao" ForeColor="Red" Text=""></asp:Label>
                    </div>
                    <div style="clear: both;"></div>
                    <asp:Panel runat="server" ID="pndata">
                        <div class="phantrang">
                            <div class="sobanghi">
                                <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                            </div>
                            <div class="sotrang">
                                <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                    OnClick="lbTBack_Click"></asp:LinkButton>
                                <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                    Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                                <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                    Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                    Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                    Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                    Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                                <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                    Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                    OnClick="lbTNext_Click"></asp:LinkButton>
                            </div>
                        </div>
                        <table class="table2" style="width: 100%; border-spacing: 0px; padding: 4px;">
                            <tr class="header">
                                <td rowspan="2">STT</td>
                                <td rowspan="2">Tên vụ án bị hủy</td>
                                <td rowspan="2">Trạng thái</td>
                                <td rowspan="2">Tòa xử</td>
                                <td rowspan="2">Vai trò</td>
                                <td colspan="2">Tự đánh giá</td>
                                <td colspan="2">Ủy ban thẩm phán đánh giá</td>
                            </tr>
                            <tr class="header">
                                <td>Đánh giá</td>
                                <td>Lý do</td>
                                <td>Đánh giá</td>
                                <td>Lý do</td>
                            </tr>
                            <asp:Repeater ID="rptData" runat="server" OnItemDataBound="rptData_ItemDataBound" OnItemCommand="rptData_ItemCommand">
                                <ItemTemplate>
                                    <tr runat="server" id="rowCss">
                                        <td style="text-align: center; width: 29px;"><%#Eval("STT") %></td>
                                        <td>
                                            <asp:LinkButton ID="lbtVuAnHuy" runat="server" Text='<%#Eval("TenVuAn") %>' CausesValidation="false" CommandName="Sua"
                                                CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                        </td>
                                        <td style="width: 65px;"><%#Eval("TrangThai") %></td>
                                        <td style="width: 130px;"><%#Eval("TenToaAn") %></td>
                                        <td style="width: 65px;"><%#Eval("VaiTro") %></td>
                                        <td style="width: 65px;"><%#Eval("TP_DanhGia") %></td>
                                        <td style="width: 140px;"><%#Eval("TP_Lydo") %></td>
                                        <td style="width: 65px;"><%#Eval("UBTP_DanhGia") %></td>
                                        <td style="width: 140px;"><%#Eval("UBTP_Lydo") %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </table>
                        <div class="phantrang">
                            <div class="sobanghi">
                                <asp:HiddenField ID="hdicha" runat="server" />
                                <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                            </div>
                            <div class="sotrang">
                                <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                    OnClick="lbTBack_Click"></asp:LinkButton>
                                <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                    Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                                <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                    Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                    Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                    Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                    Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                                <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                    Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                    OnClick="lbTNext_Click"></asp:LinkButton>
                            </div>
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
