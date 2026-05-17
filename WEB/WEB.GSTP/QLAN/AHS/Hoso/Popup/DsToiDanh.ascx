<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DsToiDanh.ascx.cs" Inherits="WEB.GSTP.QLAN.AHS.Hoso.Popup.DsToiDanh" %>
<div class="boxchung">
    <h4 class="tleboxchung">Điều luật áp dụng</h4>
    <div class="boder" style="padding: 20px 10px;">
        <span class="msg_error">
            <asp:Literal ID="LtrThongBao" runat="server"></asp:Literal></span>
        <%--<a href="javascript:;" onclick="popupDieuLuatAD();" style="float: right;" class="buttonpopup">Thêm điều luật áp dụng cho bị can đầu vụ</a>--%>
        <asp:LinkButton ID="lkThemDieuLuat" runat="server" OnClick="lkThemDieuLuat_Click" CssClass="buttonpopup them_user">Thêm điều luật áp dụng cho bị can đầu vụ</asp:LinkButton>
        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <asp:Panel ID="pnDS" runat="server">
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
                            <td width="10%">
                                <div align="center"><strong>Tên bộ luật</strong></div>
                            </td>
                            <td width="10%">
                                <div align="center"><strong>Ngày ban hành</strong></div>
                            </td>
                            <td width="50px">
                                <div align="center"><strong>Điểm</strong></div>
                            </td>
                            <td width="50px">
                                <div align="center"><strong>Khoản</strong></div>
                            </td>
                            <td width="50px">
                                <div align="center"><strong>Điều</strong></div>
                            </td>
                            <td>
                                <div align="center"><strong>Tội danh</strong></div>
                            </td>
                            <td width="70">
                                <div align="center"><strong>Thao tác</strong></div>
                            </td>
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td><%# Eval("STT") %></td>
                        <td><%#Eval("TenBoLuat") %></td>

                        <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayBanHanh")) %></td>

                        <td><%# Eval("Diem") %></td>
                        <td><%# Eval("Khoan") %></td>
                        <td><%# Eval("Dieu") %></td>
                        <td><%# Eval("TenToiDanh") %></td>

                        <td>
                            <div align="center">
                                <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"
                                    OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                            </div>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate></table></FooterTemplate>
            </asp:Repeater>
            <div class="phantrang_bottom">
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
            <script>
                function PopupCenter(pageURL, title, w, h) {
                    var left = (screen.width / 2) - (w / 2);
                    var top = (screen.height / 2) - (h / 2);
                    var targetWin = window.open(pageURL, title, 'toolbar=yes,scrollbars=yes,resizable=yes,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
                    return targetWin;
                }
                function popupDieuLuatAD() {
                    var width = 950;
                    var height = 550;
                   
                    var link = "Popup/pChonToiDanh.aspx?hsID=<%=VuAnID%>&bID=<%=BiCaoID%>";
                    PopupCenter(link, "Cập nhật quyết định và hình phạt", width, height);
                }

            </script>
    </div>
</div>
