<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.Danhmuc.CanBoToaAn.Danhsach" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="20" runat="server" />
    <style type="text/css">
        .labelTimKiem_css {
            width: 65px;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td><b>Tòa án</b></td>
                        <td>
                            <asp:DropDownList CssClass="chosen-select" ID="DropToaAn" runat="server" Width="300px" AutoPostBack="True" OnSelectedIndexChanged="DropToaAn_SelectedIndexChanged"></asp:DropDownList></td>
                        <td><b>Đơn vị trực thuộc</b></td>
                        <td>
                            <asp:DropDownList CssClass="chosen-select" ID="ddlPhongban" AutoPostBack="True" OnSelectedIndexChanged="ddlPhongban_SelectedIndexChanged" runat="server" Width="300px"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Phòng ban</b></td>
                        <td>
                            <asp:DropDownList CssClass="chosen-select" ID="ddlPhongban_sub" runat="server" Width="300px"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="labelTimKiem_css"><b>Chức danh</b></td>
                        <td style="width: 310px;">
                            <asp:DropDownList CssClass="chosen-select" ID="DropChucDanh" runat="server" Width="300px"></asp:DropDownList></td>
                        <td class="labelTimKiem_css"><b>Chức vụ</b></td>
                        <td>
                            <asp:DropDownList CssClass="chosen-select" ID="DropChucVu" runat="server" Width="300px"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td><b>Từ khóa</b></td>
                        <td>
                            <asp:TextBox ID="txKey" CssClass="user" runat="server" Width="292px" placeholder="Mã, tên, địa chỉ cán bộ"></asp:TextBox></td>
                        <td><b>Trạng thái công tác</b></td>
                        <td>
                            <asp:DropDownList CssClass="chosen-select" ID="DropTrangThaiCongTac" runat="server" Width="300px">
                                <asp:ListItem Text="--- Tất cả ---" Value="4"></asp:ListItem>
                                <asp:ListItem Text="Đang công tác" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Nghỉ phép" Value="2"></asp:ListItem>
                                <asp:ListItem Text="Nghỉ công tác" Value="0"></asp:ListItem>
                                <%--                                <asp:ListItem Text="Dừng xét xử" Value="3"></asp:ListItem>--%>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="3">
                            <asp:CheckBox ID="chkAll" runat="server" Text="Bao gồm cả các đơn vị cấp dưới." Checked="false" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" style="text-align: left;">
                            <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="3">
                            <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                            <asp:Button ID="cmdThemmoi" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="btnThemmoi_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
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
                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%"
                                OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                <Columns>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                    <asp:TemplateColumn ItemStyle-Width="40px" HeaderStyle-Width="40px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            STT
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Container.ItemIndex + 1 %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn ItemStyle-Width="70px" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Mã cán bộ
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("MACANBO")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Tên cán bộ
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("HOTEN")%>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" Width="160px"></HeaderStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn ItemStyle-Width="120px" HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Chức danh
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("CHUCDANH")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn ItemStyle-Width="120px" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Chức vụ
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("CHUCVU")%>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" Width="120px"></HeaderStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn ItemStyle-Width="120px" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Phòng ban, đơn vị trực thuộc
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("TENPHONGBAN")%>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" Width="120px"></HeaderStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn ItemStyle-Width="120px" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Tòa án
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("TOAAN_TEN")%>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" Width="120px"></HeaderStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn ItemStyle-Width="100px" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Trạng thái
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("TRANGTHAI")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn ItemStyle-Width="100px" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Tình trạng GQĐ/XX
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("TRANGTHAI_XETXU_TEN")%>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" Width="100px"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-Width="80px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Thao tác
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbtSua" runat="server" Text="Sửa" ForeColor="#0e7eee" CausesValidation="false" CommandName="Sua"
                                                CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                            &nbsp;&nbsp;
                                            <asp:LinkButton ID="lbtXoa" runat="server" ForeColor="#0e7eee" CausesValidation="false" Text="Xóa"
                                                CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa cán bộ này? ');"></asp:LinkButton>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
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
    </script>
</asp:Content>
