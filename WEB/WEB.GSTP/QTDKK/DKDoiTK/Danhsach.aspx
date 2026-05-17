<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.QTDKK.DKDoiTK.Danhsach" %>

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
                        <td style="width: 80px;">Trạng thái</td>
                        <td style="width: 200px;">
                            <asp:DropDownList CssClass="user" ID="dropStatus"
                                runat="server" Width="180px">
                                <asp:ListItem Text="Chưa duyệt" Value="0"></asp:ListItem>
                                <asp:ListItem Text="Đã duyệt" Value="1"></asp:ListItem>
                               <%-- <asp:ListItem Text="Đang khóa" Value="2"></asp:ListItem>--%>
                            </asp:DropDownList>
                        </td>
                        <td style="width: 80px;">Mã đăng ký</td>
                        <td>
                            <asp:TextBox ID="txtMaDangKy" CssClass="user" runat="server"
                                Width="200px" placeholder="Mã đăng ký"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Họ tên</td>
                        <td>
                            <asp:TextBox ID="txtHoTen" CssClass="user" runat="server" Width="172px" placeholder="Họ tên người đăng ký"></asp:TextBox>

                        </td>
                        <td>CMND</td>
                        <td>
                            <asp:TextBox ID="txtCMND" CssClass="user" runat="server" Width="200px" placeholder="CMND của người đăng ký"></asp:TextBox>
                        </td>
                    </tr>

                    <tr>
                        <td>Email</td>
                        <td colspan="3">
                            <asp:TextBox ID="txtEmaiil" CssClass="user" runat="server" Width="407px" placeholder="Email của người đăng ký"></asp:TextBox>
                            <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                            <%--<asp:Button ID="cmdThemmoi" runat="server" Visible="false" CssClass="buttoninput" Text="Thêm mới" OnClick="btnThemmoi_Click" />--%>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td style="text-align: left;" colspan="3">
                            <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
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
                            <asp:HiddenField ID="hddnewPassword" runat="server" Value="123456" />

                            <div class="CSSTableGenerator">
                                <table class="table2" style="width: 100%" border="1">
                                    <tr class="header">
                                        <td style="width: 30px;">TT</td>
                                        <td style="width: 100px">Mã đăng ký</td>
                                        <td >Tài khoản đang sử dụng</td>

                                        <td >Tài khoản mới</td>

                                        <td style="width: 80px;">Ngày ĐK</td>
                                        <td style="width: 80px;">Tình trạng</td>
                                        <td style="width: 60px;">Thao tác</td>
                                    </tr>
                                    <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                                        <ItemTemplate>
                                            <tr>
                                                <td><%#Eval("STT") %></td>
                                                <td><%#Eval("MADangKy") %></td>
                                                <td><b style="margin-right: 5px;">Họ tên:</b><%#Eval("HoTen_Old") %><br />
                                                    <b style="margin-right: 5px;">Email:</b><%#Eval("Email_Old") %><br />
                                                    <b style="margin-right: 5px;">CMND:</b><%#Eval("CMND_Old") %>
                                                </td>
                                                <td style='line-height: 20px'>
                                                    <b style="margin-right: 5px;">Họ tên:</b><%#Eval("HoTen_New") %><br />
                                                    <b style="margin-right: 5px;">Email:</b><%#Eval("Email_New") %><br />
                                                    <b style="margin-right: 5px;">CMND:</b><%#Eval("CMND_New") %>
                                                </td>
                                                <td><%# string.Format("{0:dd/MM/yyyy}",Eval("MODIFYDATE")) %></td>
                                                <td><%#Eval("STATUSTEXT") %></td>
                                                <td>
                                                    <div style="text-align: center;">

                                                        <div class="tooltip">
                                                            <asp:ImageButton ID="cmdActive" runat="server"
                                                                CssClass="grid_button"
                                                                CommandName="Active" CommandArgument='<%#Eval("ID") %>'
                                                                ImageUrl="~/UI/img/unlock.png" Width="20px" />
                                                            <span class="tooltiptext  tooltip-bottom">Duyệt đăng ký</span>
                                                        </div>
                                                        <div class="tooltip">
                                                            <asp:ImageButton ID="cmdXoa" runat="server" ToolTip="Xóa" CssClass="grid_button"
                                                                CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                ImageUrl="~/UI/img/delete.png" Width="17px"
                                                                OnClientClick="return confirm('Bạn thực sự muốn xóa đăng ký này? ');" />
                                                            <span class="tooltiptext  tooltip-bottom">Xóa đăng ký</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </table>
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

