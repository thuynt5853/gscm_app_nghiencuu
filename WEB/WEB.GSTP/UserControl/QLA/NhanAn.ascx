<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NhanAn.ascx.cs" Inherits="WEB.GSTP.UserControl.QLA.NhanAn" %>
<asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
<asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />

<asp:Panel runat="server" ID="pndata" Visible="false">
     <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
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
    <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"   PageSize="10" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"     CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
        ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgList_ItemCommand" >
        <Columns>
               <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
            <asp:BoundColumn DataField="LOAIVV" Visible="false"></asp:BoundColumn>
            <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                <HeaderTemplate>TT</HeaderTemplate>
                <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
            </asp:TemplateColumn>
            <asp:TemplateColumn HeaderStyle-Width="105px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                <HeaderTemplate>Thao tác</HeaderTemplate>
                <ItemTemplate>
                    <asp:LinkButton ID="lblSua" runat="server" Text="Nhận vụ việc" CausesValidation="false" CommandName="SELECT" ForeColor="#0e7eee" OnClientClick="return confirm('Bạn chắc chăn muốn nhận vụ việc này? ');"
                        CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateColumn>
            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" >
                <HeaderTemplate>Tên vụ việc</HeaderTemplate>
                <ItemTemplate>
                     <a style="color:#0e7eee;cursor:pointer;" onclick='popup_in(<%#Eval("ID") %>,<%#Eval("LOAIVV") %>)'>
                        <%#Eval("TENVUVIEC") %>
                    </a>
                </ItemTemplate>
            </asp:TemplateColumn>
          
            <asp:BoundColumn DataField="NGAYGIAO" HeaderText="Ngày chuyển" HeaderStyle-Width="66px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
            <asp:BoundColumn DataField="TOACHUYEN" HeaderText="Tòa án chuyển" HeaderStyle-Width="200px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
            <asp:BoundColumn DataField="THGIAONHAN" HeaderText="Trường hợp giao nhận" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="125px" ></asp:BoundColumn>
               <asp:BoundColumn DataField="LOAIVUVIEC" HeaderText="Loại vụ việc" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="66px" ></asp:BoundColumn>
          
           </Columns>
        <HeaderStyle CssClass="header"></HeaderStyle>
        <ItemStyle CssClass="chan"></ItemStyle>
        <PagerStyle Visible="false"></PagerStyle>
    </asp:DataGrid>
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
        <script type="text/javascript">
            function popup_in(ID, loaivv) {    
            
                                    var link = "/BaoCao/Thongtinvuviec/ViewInfo.aspx?cid=" + ID + "&ctype=" + loaivv;
                                        var width = 900;
                                        var height = 800;
                                        PopupReport(link, "Thông tin vụ việc", width, height);
                                }
                                function PopupReport(pageURL, title, w, h) {
                                   var left = (screen.width / 2) - (w / 2);
                                    var top = (screen.height / 2) - (h / 2);
                                    //OpenPopUpPage(pageURL, null, w, h);
                                    var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,scrollbars=yes,resizable=yes,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
                                   return targetWin;
                               }
                            </script>
</asp:Panel>
