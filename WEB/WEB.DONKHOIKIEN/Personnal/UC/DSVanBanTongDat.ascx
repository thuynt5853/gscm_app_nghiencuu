<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DSVanBanTongDat.ascx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.UC.DSVanBanTongDat" %>

<div class="guidonkien_head_nobg">
    
    <a href="/Personnal/VBTongDat.aspx" class="viewmore">Xem thêm</a>
</div>
<asp:HiddenField ID="hddSoLuong" runat="server" Value="5" />
<div class="msg_thongbao">
    <asp:Literal ID="lttMsg" runat="server"></asp:Literal>
</div>
<asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
<asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />

<asp:Panel ID="pnDS" runat="server">

    <div class="phantrang">
        <div class="sobanghi">
            <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
        </div>
        <div class="sotrang">
            <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                OnClick="lbTBack_Click"><</asp:LinkButton><asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
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
                OnClick="lbTNext_Click">></asp:LinkButton>
            <asp:DropDownList ID="dropPageSize" runat="server" Width="55px" CssClass="dangky_tk_dropbox"
                AutoPostBack="True" OnSelectedIndexChanged="dropPageSize_SelectedIndexChanged">
                 <asp:ListItem Value="5" Text="5" Selected="True"></asp:ListItem>
                <asp:ListItem Value="10" Text="10"></asp:ListItem>
                <asp:ListItem Value="20" Text="20"></asp:ListItem>
                <asp:ListItem Value="30" Text="30"></asp:ListItem>
                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                <asp:ListItem Value="200" Text="200"></asp:ListItem>
                <asp:ListItem Value="500" Text="500"></asp:ListItem>
            </asp:DropDownList>
        </div>
    </div>

    <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand">
        <HeaderTemplate>

            <div class="CSSTableGenerator">
                <table>
                    <tr id="row_header">
                        <td style="width: 20px;">TT</td>
                        <td style="width:150px;">Văn bản</td>
                        <td style="width: 65px;">Ngày gửi</td>
                        <td>Thông tin vụ việc</td>
                        <td style="width: 130px;">Trạng thái</td>
                        <td style="width: 60px;">Xem tệp đính kèm</td>
                    </tr>
        </HeaderTemplate>
        <ItemTemplate>
            <tr>
                <td><%#Eval("STT") %></td>
                <td>
                    <asp:LinkButton ID="lkVB" runat="server" Text='<%#Eval("TenVanBan") %>'
                        CommandArgument='<%#Eval("VanBanID") %>' CommandName="view"></asp:LinkButton>
                </td>
                <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayGui")) %></td>
                <td><%#Eval("TenVuViec") %> </td>
                <td><%#Eval("TrangThaiDoc") %></td>
                <td>
                    <div class="align_center">
                        <asp:ImageButton ID="imgFile" runat="server" ImageUrl="/UI/img/download_file26.png"
                            CommandArgument='<%#Eval("VanBanID") %>' CommandName="dowload" />
                    </div>
                </td>
            </tr>
        </ItemTemplate>
        <FooterTemplate>
            </table></div>
        </FooterTemplate>
    </asp:Repeater>

    <div class="phantrang">
        <div class="sobanghi">
            <asp:HiddenField ID="hdicha" runat="server" />
            <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
        </div>
        <div class="sotrang">
            <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                OnClick="lbTBack_Click"><</asp:LinkButton>
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
                OnClick="lbTNext_Click">></asp:LinkButton>
            <asp:DropDownList ID="dropPageSize2" runat="server" Width="55px" CssClass="dangky_tk_dropbox"
                AutoPostBack="True" OnSelectedIndexChanged="dropPageSize_SelectedIndexChanged">
                 <asp:ListItem Value="5" Text="5" Selected="True"></asp:ListItem>
                <asp:ListItem Value="10" Text="10"></asp:ListItem>
                <asp:ListItem Value="20" Text="20"></asp:ListItem>
                <asp:ListItem Value="30" Text="30"></asp:ListItem>
                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                <asp:ListItem Value="200" Text="200"></asp:ListItem>
                <asp:ListItem Value="500" Text="500"></asp:ListItem>
            </asp:DropDownList>
        </div>
    </div>
</asp:Panel>
