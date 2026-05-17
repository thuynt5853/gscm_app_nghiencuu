<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="pDuongSuKhac.ascx.cs" Inherits="WEB.GSTP.QLAN.ADS.Hoso.Popup.pDuongSuKhac" %>
<asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
<asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />

<script>
    function popup_edit_duongsu(DuongSuID) {

        var link = "";
        if (DuongSuID > 0)
            link = "Popup/pDuongsu.aspx?hsID=<%=DonID%>&bID=" + DuongSuID;
        else
            link = "Popup/pDuongsu.aspx?hsID=<%=DonID%>";
        var width = 950;
        var height = 400;
        PopupCenter(link, "Đương sự khác", width, height);
    }
    function PopupCenter(pageURL, title, w, h) {
        var left = (screen.width / 2) - (w / 2);
        var top = (screen.height / 2) - (h / 2);
        var targetWin = window.open(pageURL, title, 'toolbar=yes,scrollbars=yes,resizable=yes,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
        return targetWin;
    }
</script>
<div class="boxchung">
    <h4 class="tleboxchung">Đương sự khác</h4>
    <div class="boder" style="padding: 20px 10px;">
        <span class="msg_error">
            <asp:Literal ID="LtrThongBao" runat="server"></asp:Literal></span>
        <asp:LinkButton ID="lkThemNguoiTGTT" runat="server" CssClass="buttonpopup them_user" OnClick="lkThemNguoiTGTT_Click">Thêm đương sự khác</asp:LinkButton>
        <asp:Panel ID="pnDS" runat="server">
            <div class="phantrang" style="display: none;">
                <div class="sobanghi">
                    <asp:Literal ID="lstSobanghiT" Visible="false" runat="server"></asp:Literal>
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
            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                ItemStyle-CssClass="chan" Width="100%"
                OnItemCommand="dgList_ItemCommand">
                <Columns>
                    <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                        <HeaderTemplate>
                            TT
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%# Container.DataSetIndex + 1 %>
                        </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                        <HeaderTemplate>
                            Tên đương sự
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%#Eval("TENDUONGSU") %>
                        </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                        <HeaderTemplate>
                            Địa chỉ (Thường trú/Trụ sở chính)
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%#Eval("DIACHIDS") %>
                        </ItemTemplate>
                    </asp:TemplateColumn>
<%--                    <asp:TemplateColumn HeaderStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                        <HeaderTemplate>
                            Thụ lý
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%#Eval("THULY") %>
                        </ItemTemplate>
                    </asp:TemplateColumn>--%>
                    <asp:TemplateColumn HeaderStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                        <HeaderTemplate>
                            Đương sự là
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%#Eval("TENLOAIDS") %>
                        </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                        <HeaderTemplate>
                            Tư cách tố tụng
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%#Eval("TENTCTT") %>
                        </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                        <HeaderTemplate>
                            Thao tác
                        </HeaderTemplate>
                        <ItemTemplate>
                            <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                            &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateColumn>
                </Columns>
                <HeaderStyle CssClass="header"></HeaderStyle>
                <ItemStyle CssClass="chan"></ItemStyle>
                <PagerStyle Visible="false"></PagerStyle>
            </asp:DataGrid>
            <div class="phantrang_bottom">
                <div class="sobanghi">
                    <asp:Literal ID="lstSobanghiB" Visible="false" runat="server"></asp:Literal>
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

