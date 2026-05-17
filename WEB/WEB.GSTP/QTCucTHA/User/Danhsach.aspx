<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" 
CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.QTCucTHA.User.Danhsach" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
<asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <div class="box">
   
    <div class="box_nd">
        <div class="truong">
       <%--   DL duoc lay trong bảng  TuPhap_NguoiSuDung : Luu ý: thêm cột  DonViTHA_ID--%>
     <table class="table1">
                <tr>
                    <td style="width: 150px;" align="left">
                        <b>Chọn đơn vị</b>
                    </td>
                    <td align="left">
                        <asp:DropDownList  CssClass="chosen-select"  ID="ddlDonvi" runat="server" Width="500px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr style="display:none;">
                    <td style="width: 150px;" align="left">
                        <b>Tên đơn vị</b>
                    </td>
                    <td align="left">
                        <asp:TextBox ID="txtDonvi" CssClass="user" runat="server" Width="90%"></asp:TextBox>
                    </td>
                </tr>
               <tr >
                    <td style="width: 150px;" align="left">
                         <b>Phạm vi tìm kiếm</b>
                    </td>
                    <td align="left">
                          <asp:DropDownList  CssClass="chosen-select"  ID="ddlLoaiNhom" runat="server" Width="150px">
                            <asp:ListItem Value="0" Text="Bao gồm cấp con"></asp:ListItem>
                            <asp:ListItem Value="1" Text="Chỉ thuộc đơn vị"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 150px;" align="left">
                        <b>User name</b>
                    </td>
                    <td align="left">
                        <asp:TextBox ID="txtUserName" CssClass="user" runat="server" Width="90%"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 150px;" align="left">
                        <b>Họ tên/ Email/ Điện thoại</b>
                    </td>
                    <td align="left">
                        <asp:TextBox ID="txtHoten" CssClass="user" runat="server" Width="90%"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="left">
                   
                    <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 150px;" align="left">
                    </td>
                    <td align="left">
                            <asp:Button ID="cmdTimkiem" runat="server" cssclass="buttoninput" Text="Tìm kiếm"  onclick="lbtimkiem_Click"  />
                            <asp:Button ID="cmdThemmoi" runat="server" cssclass="buttoninput" Text="Thêm mới"  onclick="btnThemmoi_Click"  />
                     
                    </td>
                </tr>
                <tr>
                <td colspan="2" align="left">
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
                    <div>
                        <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                            PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                            ItemStyle-CssClass="chan" Width="100%"
                            OnItemCommand="dgList_ItemCommand">
                            <Columns>
                                <asp:BoundColumn DataField="Id" Visible="false"></asp:BoundColumn>
                                 <asp:BoundColumn DataField="LoaiUser" Visible="false"></asp:BoundColumn>
                                <asp:TemplateColumn ItemStyle-Width="30px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        STT
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                       <%# Container.ItemIndex + 1 %>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        User name
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#Eval("USERNAME")%>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn  HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        Họ tên
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#Eval("HOTEN")%>
                                    </ItemTemplate>
                                </asp:TemplateColumn>      
                                 <asp:TemplateColumn ItemStyle-Width="150px" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                       Tên đơn vị
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#Eval("TenDonVi")%>
                                    </ItemTemplate>
                                </asp:TemplateColumn>   
                                <asp:TemplateColumn  HeaderStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                     Nhóm người dùng
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                          <%#Eval("TenNhomNSD")%>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" Width="120px"></HeaderStyle>
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="50px" ItemStyle-Width="50px" HeaderStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                       Hiệu lực ?
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkHieuluc" Enabled="false" runat="server" Checked='<%# GetBool(Eval("HIEULUC"))%>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" Width="50px"></HeaderStyle>
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:TemplateColumn>
                               
                                <asp:TemplateColumn HeaderStyle-Width="180px" ItemStyle-Width="180px" HeaderStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        Thao tác
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                          &nbsp;
                                        <asp:LinkButton ID="lblReset" runat="server" ForeColor="#0e7eee" Text="Khởi tạo mật khẩu" CausesValidation="false" CommandName="Reset"
                                            CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                        &nbsp;
                                       &nbsp;
                                        <asp:LinkButton ID="lblSua" runat="server"  Text="Sửa"   ForeColor="#0e7eee" CausesValidation="false" CommandName="Sua"
                                            CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                        &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa"  runat="server"   ForeColor="#0e7eee" CausesValidation="false" Text="Xóa"
                                            CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa người dùng này? ');"></asp:LinkButton>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" ></HeaderStyle>
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:TemplateColumn>
                            </Columns>
                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                        </asp:DataGrid>
                    </div>
                    <div class="phantrang">
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
                </td>
                </tr>
               
            </table>
        </div>
    </div>
</div>
          <script type="text/javascript">          
        function pageLoad(sender, args) {       
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
