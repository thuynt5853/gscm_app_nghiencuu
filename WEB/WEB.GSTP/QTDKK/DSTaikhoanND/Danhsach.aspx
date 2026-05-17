<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.QTDKK.DSTaikhoanND.Danhsach" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="20" runat="server" />
    <style type="text/css">
        .labelTimKiem_css {
            width: 85px;
        }

        .grid_button {
            margin-right: 10px;
            float: left;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                      <tr>
                        <td style="font-weight:bold;">Loại tài khoản</td>
                        <td style="text-align: left;">
                             <asp:DropDownList CssClass="user" ID="dropLoaiUser" runat="server" Width="150px">
                            </asp:DropDownList>
                            <b style="margin-left:20px;margin-right:5px;">Mục đích sử dụng</b>
                            <asp:DropDownList CssClass="user" ID="dropMucdichSD" runat="server" Width="200px">
                             <%--<asp:DropDownList CssClass="user" ID="dropCKS" runat="server" Width="200px">--%>
                            </asp:DropDownList>
                            
                            <b style="margin-left:20px;margin-right:5px;">ĐK Thay đổi</b>
                             <asp:DropDownList CssClass="user" ID="dropDKThaydoi" runat="server" Width="200px">
                                <asp:ListItem Value="0"> Tất cả </asp:ListItem>
                                <asp:ListItem Value="1"> Chưa thay đổi </asp:ListItem>
                                <asp:ListItem Value="3"> Đã thay đổi </asp:ListItem>
                                <asp:ListItem Value="2"> Có yêu cầu thay đổi </asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td style="width:80px;font-weight:bold;">Từ khóa</td>
                        <td>
                            <asp:TextBox ID="txKey" CssClass="user" runat="server" Width="300px" placeholder="Email người đại diện"></asp:TextBox>
                           
                            <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                            <asp:Button ID="cmdThemmoi" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="btnThemmoi_Click" />
                        </td>
                    </tr>
                    
                    <tr>
                        <td></td>
                        <td style="text-align: left;">
                            <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
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
                            <asp:HiddenField ID="hddnewPassword" runat="server" Value="123456" />
                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False"
                                CellPadding="4"  GridLines="None"
                                PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header"
                                AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%"
                                OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                <Columns>
                                    <asp:BoundColumn DataField="Id" Visible="false"></asp:BoundColumn>
                                    <asp:TemplateColumn ItemStyle-Width="30px" HeaderStyle-Width="30px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            STT
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Container.ItemIndex + 1 %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Họ và Tên
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("NDD_HOTEN")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Email
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("EMAIL")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Trạng thái
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("STATUSTEXT")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="250px"
                                        HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                           Mục đích sử dụng
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <div style="text-align:center;"><%#Eval("SuDungCKS")%></div> 
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="150px"
                                        HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                           ĐK Thay đổi
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <div style="text-align:center;"><%#Eval("DKThaydoi")%></div> 
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Thao tác
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <div style="text-align: center;">
                                                <div class="tooltip">
                                                    <asp:ImageButton ID="cmdLock" runat="server" ToolTip="Khóa" CssClass="grid_button"
                                                        CommandName="Khoa" CommandArgument='<%#Eval("ID") %>'
                                                        ImageUrl="~/UI/img/lock.png" Width="20px" />
                                                    <span class="tooltiptext  tooltip-bottom">Khóa tài khoản</span>
                                                </div>
                                                <div class="tooltip">
                                                    <asp:ImageButton ID="cmdUnlock" runat="server" ToolTip="Kích hoạt" CssClass="grid_button"
                                                        CommandName="KichHoat" CommandArgument='<%#Eval("ID") %>'
                                                        ImageUrl="~/UI/img/unlock.png" Width="20px" />
                                                    <span class="tooltiptext  tooltip-bottom">Kích hoạt tài khoản</span>
                                                </div>
                                                <div class="tooltip">
                                                    <asp:ImageButton ID="cmdEdit" runat="server" ToolTip="Sửa" CssClass="grid_button"
                                                        CommandName="Sua" CommandArgument='<%#Eval("ID") %>'
                                                        ImageUrl="~/UI/img/edit_doc.png" Width="18px" />
                                                    <span class="tooltiptext  tooltip-bottom">Sửa tài khoản</span>
                                                </div>
                                                <div class="tooltip" >
                                                    <asp:ImageButton ID="cmdXoa" runat="server" ToolTip="Xóa" CssClass="grid_button"
                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                        ImageUrl="~/UI/img/delete.png" Width="17px"
                                                        OnClientClick="return confirm('Bạn thực sự muốn xóa tài khoản này? ');" />
                                                    <span class="tooltiptext  tooltip-bottom">Xóa tài khoản</span>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
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

        function khoitaomatkhau() {
            var hddnewPassword = document.getElementById('<%=hddnewPassword.ClientID%>');
            var initPassword = prompt("Hãy nhập mật khẩu khởi tạo cho tài khoản", "123456");
            hddnewPassword.value = initPassword;
            if (!Common_CheckEmpty(hddnewPassword.value)) {
                alert('Mật khẩu không được khởi tạo, hãy kiểm tra lại.');
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
