<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="DsBiCao.aspx.cs"
    Inherits="WEB.GSTP.QLAN.AHS.Hoso.DsBiCao" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddGiaiDoanVuAn" Value="" runat="server" />
    <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
    <div class="box">
        <div class="box_nd" style="padding: 0px 15px;">

            <div style="margin: 5px; text-align: center; width: 95%; float: left;">
                <table class="table1">
                    <tr>
                        <td>
                            <span>Từ khóa</span>
                            <asp:TextBox ID="txtKey" runat="server" CssClass="user" Width="200px"></asp:TextBox>
                            <asp:Button ID="cmdSearch" runat="server" CssClass="buttoninput"
                                Text="Tìm kiếm" OnClick="cmdSearch_Click" />
                        </td>
                    </tr>
                </table>
            </div>
            <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                <asp:Literal ID="lstMsgB" runat="server"></asp:Literal>
            </div>
            <asp:Panel ID="pndata" runat="server">
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
                <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                    <HeaderTemplate>
                        <table class="table2" width="100%" border="1">
                            <tr class="header">
                                <td width="42">
                                    <div align="center"><strong>TT</strong></div>
                                </td>
                                <td width="70px">
                                    <div align="center"><strong>BC đầu vụ</strong></div>
                                </td>
                                <td style="width: 20%">
                                    <div align="center"><strong>Bị can</strong></div>
                                </td>

                                <td width="70px">
                                    <div align="center"><strong>Năm sinh</strong></div>
                                </td>
                                <td width="100px">
                                    <div align="center"><strong>Ngày tham gia</strong></div>
                                </td>
                                <%--GTEL-DUCPH 18-09-2025 15h:35 Thêm trạng thái xác thực vào grid--%>
                                <td width="150px">
                                    <div align="center"><strong>Trạng thái xác thực</strong></div>
                                </td>
                                <%-- END GTEL-DUCPH 18-09-2025 15h:35 Thêm trạng thái xác thực vào grid--%>
                                <td>
                                    <div align="center"><strong>Tội danh chính</strong></div>
                                </td>
                                <td width="70">
                                    <div align="center"><strong>Thao tác</strong></div>
                                </td>
                            </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><%# Eval("STT") %></td>
                            <td>
                                <div align="center">
                                    <asp:CheckBox ID="chk" runat="server" Enabled="false" Checked='<%# (Convert.ToInt16(Eval("BICANDAUVU"))>0)? true:false %>' />
                                </div>
                            </td>
                            <td><%#Eval("TenBiCao") %>
                                <%# String.IsNullOrEmpty( Eval("DCTamTru") +"") ? "":( "<br/><b>Tạm trú:</b> " +Eval("DCTamTru"))%>
                            </td>
                            <td><%# Eval("NamSinh") %></td>
                            <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayThamGia")) %></td>
                            <%--GTEL-DUCPH 18-09-2025 15h:35 Thêm trạng thái xác thực vào grid--%>
                            <td><%#Eval("TrangThaiXacThuc") %></td>
                            <%-- END GTEL-DUCPH 18-09-2025 15h:35 Thêm trạng thái xác thực vào grid--%>
                            <td><%# Eval("TenToiDanh") %></td>

                            <td>
                                <div align="center">
                                    <asp:LinkButton ID="lblSua" runat="server" Text="Sửa"
                                        CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                        CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                    &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server"
                                        CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                    <br />
                                    <%-- GTEL-DUCPH 18-09-2025: Thêm command để xem lịch sử sửa đổi của bị can--%>
                                    <asp:LinkButton ID="LinkButton1" runat="server" Text="Xem lịch sử"
                                        CausesValidation="false" CommandName="History" ForeColor="#0e7eee"
                                        CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                </div>
                            </td>
                            <td style="display: none;">
                                <asp:HiddenField ID="hddToaGiaiQuyetID" runat="server" Value='<%#Eval("TOA_GIAIQUYET_ID") %>' />
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate></table></FooterTemplate>
                </asp:Repeater>

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
</asp:Content>
