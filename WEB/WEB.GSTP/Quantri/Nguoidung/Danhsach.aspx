<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.Quantri.Nguoidung.Danhsach" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <div class="box">

        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td style="width: 150px;" align="left">
                            <b>Chọn đơn vị</b>
                        </td>
                        <td align="left">
                            <asp:DropDownList CssClass="chosen-select" ID="ddlDonvi" runat="server" Width="500px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td style="width: 150px;" align="left">
                            <b>Tên đơn vị</b>
                        </td>
                        <td align="left">
                            <asp:TextBox ID="txtDonvi" CssClass="user" runat="server" Width="90%"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 150px;" align="left">
                            <b>Phạm vi tìm kiếm</b>
                        </td>
                        <td align="left">
                            <asp:DropDownList CssClass="chosen-select" ID="ddlLoaiNhom" runat="server" Width="150px">
                                <asp:ListItem Value="0" Text="Bao gồm cấp con"></asp:ListItem>
                                <asp:ListItem Value="1" Text="Chỉ thuộc đơn vị"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 150px;" align="left">
                            <b>Tài khoản đăng nhập</b>
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
                        <td style="width: 150px;" align="left"></td>
                        <td align="left">
                            <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                            <asp:Button ID="cmdThemmoi" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="btnThemmoi_Click" />

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
                                                Tài khoản
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("USERNAME")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center">
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
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Nhóm người dùng
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TenNhomNSD")%>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" Width="120px"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Phòng ban, đơn vị trực thuộc
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("PB_DONVITT")%>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" Width="100px"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="left"></ItemStyle>
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
                                        <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" ForeColor="#0e7eee" CausesValidation="false" CommandName="Sua"
                                            CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" ForeColor="#0e7eee" CausesValidation="false" Text="Xóa"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa người dùng này? ');"></asp:LinkButton>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
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
        function CopyToClipboard() {
            var copyText = document.getElementById("<%=passRS.ClientID %>").innerText;

            navigator.clipboard.writeText(copyText)
                //.then(() => { alert('Copied to clipboard.') })
                .catch((error) => { alert('Copy failed. Error: ${error}') })
        }
    </script>

    <div runat="server" id="mymodal" style="display: none; visibility: hidden; position: absolute!important;"></div>
    <cc1:ModalPopupExtender ID="modalDs" BehaviorID="modal_ThongBao"
        runat="server" PopupControlID="pnCapnhat"
        TargetControlID="mymodal"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>

    <asp:Panel ID="pnCapnhat" runat="server" align="center" CssClass="modalPopup" Style="display: none; height: 100%; width: 900px; top: 20px;">
        <div class="box_nd" style="width: 683px; padding-top: 210px;">
            <div class="boder" style="padding: 10px; background-color: antiquewhite; border: 1px solid black; border-radius: 10px;">
                <table class="table1">
                    <tr>
                        <td style="text-align: center;" id="Td1" runat="server">
                            <h1 id="H1" runat="server" style="font-size: 20px; color: red;">THÔNG BÁO
                            </h1>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center;" id="txtthongbao" runat="server">
                            <h1 id="lblthongbao" class="js-text" runat="server" style="font-size: 18px;"></h1>
                            <h1 id="passRS" class="js-text" runat="server" style="display: none"></h1>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center;" colspan="6">
                            <asp:Button ID="copyButton" style="width: 105px;height: 34px;" runat="server" Text="Đóng và Copy" OnClientClick="CopyToClipboard()" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </asp:Panel>
</asp:Content>
