<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ThongKeVanBanTongDatChuaDangCTTDT.ascx.cs" Inherits="WEB.GSTP.UserControl.QLA.ThongKeVanBanTongDatChuaDangCTTDT" %>
<asp:HiddenField ID="hddPageSize" Value="10" runat="server" />
<asp:HiddenField ID="hddPageIndexCT" Value="1" runat="server" />
<asp:HiddenField ID="hddTotalPageCT" Value="1" runat="server" />
<asp:HiddenField ID="hddList_Menu_LoaiAn" Value="" runat="server" />
<asp:Panel ID="pnData" runat="server" Visible="false">
    <div style="float: left; width: 98%; margin: 10px 1%;">
        <div class="tk_boxchung">
            <h4 class="tk_tleboxchung">danh sách văn bản tống đạt chưa đăng cổng thông tin điện tử</h4>
            <div class="tk_boder_content">
                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                <div class="phantrang" id="PhanTrangT" runat="server">
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
                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                    PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                    ItemStyle-CssClass="chan" Width="100%">
                    <Columns>
                        <asp:BoundColumn DataField="TT" HeaderText="TT" HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                        <asp:BoundColumn DataField="MABM" HeaderText="Mã văn bản" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                        <asp:BoundColumn DataField="TENBM" HeaderText="Tên văn bản" HeaderStyle-Width="250px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                        <asp:BoundColumn DataField="TENVUVIEC" HeaderText="Tên vụ án/vụ việc" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                        <asp:BoundColumn DataField="LinhVuc" HeaderText="Lĩnh vực" HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                    </Columns>
                    <HeaderStyle CssClass="header"></HeaderStyle>
                    <ItemStyle CssClass="chan"></ItemStyle>
                    <PagerStyle Visible="false"></PagerStyle>
                </asp:DataGrid>
                <div class="phantrang" id="PhanTrangB" runat="server">
                    <div class="sobanghi">
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
            </div>
        </div>
    </div>
</asp:Panel>
