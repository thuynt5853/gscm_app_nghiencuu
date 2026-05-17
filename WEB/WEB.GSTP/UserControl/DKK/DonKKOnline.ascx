<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DonKKOnline.ascx.cs" Inherits="WEB.GSTP.UserControl.DKK.DonKKOnline" %>
<asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
<asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
<asp:HiddenField ID="hddPageSize" Value="6" runat="server" />
<style>
    .title_group {
        margin-bottom: 10px;
        text-transform: uppercase;
        font-weight: bold;
        float: left;
        width: 100%;
    }
</style>
<div style="display: none">
    <asp:Button ID="cmdLoadDSDonKK" runat="server"
        Text="Load ds donkk" OnClick="cmdLoadDSDonKK_Click" />
</div>
<asp:Panel ID="pnDonKK" runat="server">
    <div style="float: left; width: 98%; margin: 0px 1%;">
        <div class="tk_boxchung">
            <h4 class="tk_tleboxchung">phân loại đơn khởi kiện trực tuyến</h4>
            <div class="tk_boder_content">

                <asp:Panel runat="server" ID="pnPagingTop" Visible="false">
                    <div class="phantrang" style="float: left; width: 100%;">
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
                </asp:Panel>
                <asp:Repeater ID="rpt" runat="server"
                    OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                    <HeaderTemplate>
                        <table class="table2" style="width: 100%" border="1">
                            <tr class="header">
                                <td style="width: 30px;">TT </td>
                                <td style="width: 200px;">Người khởi kiện</td>
                                <td style="width: 50px;">Ngày gửi</td>
                                <td>Nội dung</td>
                                <td>Email</td>
                                <td>Số điện thoại</td>
                                <td style="width: 120px;">Thao tác</td>
                            </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr class="chan">
                            <td><%#Eval("STT") %>
                                <asp:HiddenField ID="hddVuAnID" runat="server" Value='<%#Eval("VuAnID") %>' />
                            </td>
                            <td><%#Eval("TenNguoiGui") %></td>
                            <td><%# string.Format("{0:dd/MM/yyyy hh:mm tt}",Eval("NgayTao")) %></td>
                            <td><a onclick="popup_xulydonkk('<%#Eval("ID") %>')"><%#Eval("TenVuViec") %></a></td>
                            <td><%#Eval("EMAIL") %></td>
                            <td><%#Eval("DIENTHOAI") %></td>
                            <td>
                                <a id="lkXuLy" href="javascript:" class="xulydon"
                                    onclick="popup_xulydonkk('<%#Eval("ID") %>')">Phân loại đơn</a>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                        <tr class="le">
                            <td><%#Eval("STT") %>
                                <asp:HiddenField ID="hddVuAnID" runat="server" Value='<%#Eval("VuAnID") %>' />
                            </td>
                            <td><%#Eval("TenNguoiGui") %></td>
                            <td><%# string.Format("{0:dd/MM/yyyy hh:mm tt}",Eval("NgayTao")) %></td>
                            <td><a onclick="popup_xulydonkk('<%#Eval("ID") %>')"><%#Eval("TenVuViec") %></a></td>
                            <td><%#Eval("EMAIL") %></td>
                            <td><%#Eval("DIENTHOAI") %></td>
                            <td>
                                <a id="lkXuLy" href="javascript:" class="xulydon"
                                    onclick="popup_xulydonkk('<%#Eval("ID") %>')">Phân loại đơn</a>
                            </td>
                        </tr>
                    </AlternatingItemTemplate>
                    <FooterTemplate></table> </FooterTemplate>
                </asp:Repeater>
                <asp:Panel runat="server" ID="pnPagingBottom" Visible="false">
                    <div class="phantrang" style="width: 100%;">
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
</asp:Panel>
<script type="text/javascript">
    //alert("strMaCT=" + <%=strMaCT%>);
    function LoadDsDonOnline() {
        $("#<%= cmdLoadDSDonKK.ClientID %>").click();
    }

    function popup_xulydonkk(donkk_id) {
        var para = "";
        var pageURL = "/UserControl/DKK/pXuLyDonKK.aspx";
        if (donkk_id > 0)
            pageURL += "?dkkID=" + donkk_id;

        var page_width = 880;
        var page_height = 750;
        var left = (screen.width / 2) - (page_width / 2);
        var top = (screen.height / 2) - (page_height / 2);
        var targetWin = window.open(pageURL, 'Xử lý đơn khởi kiện online'
            , 'toolbar=no,scrollbars=yes,resizable=yes'
            + ', width = ' + page_width
            + ', height=' + page_height + ', top=' + top + ', left=' + left);
        return targetWin;
    }
</script>

