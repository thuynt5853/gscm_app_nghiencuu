<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DsDuongSu.ascx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.UC.DsDuongSu" %>

<asp:Panel ID="pnDuongSu" runat="server">
    <div class="boxchung">
        <h4 class="tleboxchung">Đương sự</h4>
        <div class="boder">
            <asp:Literal ID="lttLink" runat="server"></asp:Literal>
            <asp:Panel runat="server" ID="pnDanhSach" Visible="false">
                <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
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

                <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand">
                    <HeaderTemplate>
                        <div class="CSSTableGenerator">
                            <table>
                                
                                    <tr id="row_header">
                                        <td style="width: 20px;">TT</td>
                                        <td>Đương sự</td>
                                        <%-- <td>Địa chỉ (Thường trú/Trụ sở chính)</td>--%>
                                        <td>Đương sự là</td>
                                        <td>Tư cách tố tụng</td>
                                       <%-- <td>Đại diện</td>--%>
                                        <td style="width: 70px;">Thao tác</td>
                                    </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><%# Container.ItemIndex + 1 %>
                                <asp:HiddenField ID="hddTaiLieuID" runat="server"
                                    Value=' <%#Eval("ID") %>' />
                            </td>
                            <td>
                                <div style="text-align: justify; float: left;">
                                    <%#Eval("TENDUONGSU") %>
                                </div>
                            </td>

                            <td><%#Eval("TENLOAIDS") %></td>
                            <td><%#Eval("TuCachToTung") %></td>
                           <%-- <td>
                                <div style="text-align: center;"><%#Eval("DAIDIEN") %></div>
                            </td>--%>
                            <td>
                                <div style="text-align: center;">
                                    <asp:ImageButton ID="imgXoa" runat="server" ImageUrl="/UI/img/delete.png"
                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                        ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa mục này? ');"></asp:ImageButton>
                                </div>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate></table></div></FooterTemplate>
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
    <script>
    function show_popup_ds() {
        var para = "";
        var loai_ds = '<%=KHAC%>';
            var loai_vuviec = '<%=MaLoaiVV%>';
            if (loai_vuviec != "") {
                var pageURL = "/Personnal/Duongsu.aspx";

                para = "?loaivv=" + loai_vuviec;
                if (hddID.value != "0")
                    para += "&dkkID=<%=DonID%>";
                if (para.length > 0)
                    para += "&loaids=" + loai_ds;
                pageURL += para;

                var page_width = 950;
                var page_height = 550;
                var left = (screen.width / 2) - (page_width / 2);
                var top = (screen.height / 2) - (page_height / 2);
                var targetWin = window.open(pageURL, 'Đương sự'
                    , 'toolbar=yes,scrollbars=yes,resizable=yes'
                    + ', width = ' + page_width
                    + ', height=' + page_height + ', top=' + top + ', left=' + left);
                return targetWin;
            } else {
                alert('Bạn cần chọn mục quan hệ pháp luật!');
                return false;
            }
    }

    </script>

</asp:Panel>
