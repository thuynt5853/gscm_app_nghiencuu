<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="NhanUyThacTHA.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.NhanUyThacTHA" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        
    </style>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                                <asp:Literal ID="lttMsg" runat="server"></asp:Literal>
                            </div>
                            <div class="boxchung">
                                <h4 class="tleboxchung">Tìm kiếm</h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        <tr>
                                            <td style="width: 75px;">Lựa chọn</td>
                                            <td style="width: 250px;">
                                                <asp:DropDownList ID="dropLoaiLuaChon" CssClass="dropbox"
                                                    Width="180px" OnSelectedIndexChanged="dropLoaiLuaChon_SelectedIndexChanged"
                                                    AutoPostBack="true"
                                                    runat="server">
                                                </asp:DropDownList></td>
                                            <td style="width: 100px;">Tòa án ủy thác</td>
                                            <td>
                                                <asp:HiddenField ID="hddToaAnUyThacID" runat="server" />
                                                <asp:TextBox ID="txtToaAnUyThac" CssClass="user" runat="server" Width="250px" placeholder="Gõ mã hoặc tên để chọn tòa án nhận ủy thác"
                                                    MaxLength="250" AutoCompleteType="Search"></asp:TextBox></td>
                                        </tr>
                                        <tr>
                                            <td style="width: 75px;">Tên bị án</td>
                                            <td>
                                                <asp:TextBox ID="txtTenBiAn" CssClass="user" runat="server" Width="180px"
                                                    MaxLength="250"></asp:TextBox>
                                            </td>
                                            <td>Tên vụ án</td>
                                            <td>
                                                <asp:TextBox ID="txtTenVuAn" CssClass="user" runat="server" Width="250px"
                                                    MaxLength="250"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 75px;">Số quyết định</td>
                                            <td>
                                                <asp:TextBox ID="txtSoQD" CssClass="user" runat="server" Width="180px"
                                                    MaxLength="250"></asp:TextBox>
                                            </td>
                                            <td>Ngày quyết định</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayQD" runat="server" CssClass="user" Width="250px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayQD" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayQD" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 75px;">Ngày ủy thác</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayUyThac" runat="server" CssClass="user" Width="180px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayUyThac" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayUyThac" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayUyThac" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                            </td>
                                            <td></td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div style="float: left; width: 105px; line-height: 20px;">Ngày QĐ từ ngày</div>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="180px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="txtTuNgay_CalendarExtender" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                            </td>
                                            <td>
                                                <div style="float: left; line-height: 20px; margin-right: 6px;">Đến ngày</div>
                                            </td>
                                            <td>
                                                <div style="float: left;">
                                                    <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="250px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtDenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 150px; text-align: left;"></td>
                        <td style="text-align: left;">
                            <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                            <asp:Button ID="cmdThemmoi" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="btnThemmoi_Click" Visible="false" />
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: left;">
                            <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: left;">
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                    <asp:DropDownList ID="ddlPageCount" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <!--------------------------------------->
                            <asp:HiddenField ID="hddBiAnID" runat="server" />
                            <%-- <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" >
                                <HeaderTemplate>
                                    <table class="table2" style="width: 100%" border="1">
                                        <tr class="header">
                                            <td style="width: 42px;">
                                                <div class="header_cell">TT</div>
                                            </td>
                                            <td>
                                                <div class="header_cell">Quyết định thi hành án</div>
                                            </td>
                                            <td style="width: 120px;">
                                                <div class="header_cell">Tòa án ủy thác</div>
                                            </td>
                                            <td>
                                                <div class="header_cell">Lý do</div>
                                            </td>
                                            <td style="width: 85px;">
                                                <div class="header_cell">Ngày ủy thác</div>
                                            </td>
                                            <td style="width: 100px;">
                                                <div class="header_cell">Người nhập</div>
                                            </td>
                                            <td style="width: 70px;">
                                                <div class="header_cell">Thao tác</div>
                                            </td>
                                        </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <asp:Button ID="cmd" runat="server" Text="Nhận ủy thác"
                                                CommandName="sua" CommandArgument='<%#Eval("ID") %>' /></td>
                                        <td>
                                            <b>- Mã QĐ:</b>  <%# Eval("MAQD") %><br />
                                            <b>- Số QĐ:</b>  <%# Eval("SoQD") %> - Ngày <%# Eval("NGAYQD") %>
                                            <br />
                                            <b>- Quyết định:</b>  <%# Eval("TENQD") %><br />
                                        </td>
                                        <td><%# Eval("TenToaAnUyThac")%></td>
                                        <td><%# Eval("TenLyDo")%></td>
                                        <td><%# string.Format("{0:dd/MM/yyyy}", Eval("NgayUyThac")) %><br />
                                        </td>
                                        <td><%# Eval("TenNguoiNhap") %></td>
                                        <td>
                                            <div class="header_cell">
                                                <asp:LinkButton ID="lbtSua" runat="server" Text="Sửa" CausesValidation="false"
                                                    CommandName="sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false"
                                                    Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"
                                                    OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                            </div>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>--%>
                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4" PageSize="10" AllowPaging="True"
                                GridLines="None" PagerStyle-Mode="NumericPages" CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                OnItemDataBound="dgList_ItemDataBound"
                                ItemStyle-CssClass="chan" Width="100%">
                                <Columns>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>STT</HeaderTemplate>
                                        <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn  HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>QĐ ủy thác thi hành án</HeaderTemplate>
                                        <ItemTemplate>
                                            <%--- Mã QĐ: <b><%# Eval("MAQD") %></b><br />
                                            - Số QĐ: <b> <%# Eval("SoQD") %> - Ngày <%# Eval("NGAYQD") %></b>
                                            <br />
                                            - Quyết định: <b><%# Eval("TENQD") %></b><br />--%>
                                            - Tên bị án: <b> <%# Eval("TENBIAN") %></b> 
                                            <br />
                                            - Tội danh: <b> <%# Eval("TENTOIDANH") %></b> 
                                            <br />
                                            - Số QĐ ủy thác: <b> <%# Eval("SoQD") %></b>
                                                <br />
                                            - Ngày QĐ ủy thác: <b> <%# Eval("NGAYQD") %></b>
                                            

                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn  HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Tòa ủy thác</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("TenToaAnUyThac")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn  HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Lý do ủy thác</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("TenLyDo")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Ngày nhận</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# string.Format("{0:dd/MM/yyyy}", Eval("NGAYNHANUYTHAC")) %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Người nhận</HeaderTemplate>
                                        <ItemTemplate>
                                           <%# Eval("NGUOINHANDANHAP")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Ngày ủy thác</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# string.Format("{0:dd/MM/yyyy}", Eval("NgayUyThac")) %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Người nhập</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("TenNguoiNhap") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thao tác</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Button ID="btnNhanUyThac" runat="server" Text="Nhận ủy thác" OnClick="btnNhanUyThacOnClick" CssClass="buttonchitiet" CausesValidation="false"
                                                CommandName="btnNhanUyThac" CommandArgument='<%#Eval("ID") %>' ></asp:Button>
                                            <asp:Button ID="btnHuyNhan" runat="server" Text="Hủy nhận" OnClick="btnHuyNhanOnClick" CssClass="buttonchitiet" CausesValidation="false"
                                                OnClientClick="return confirm('Bạn thực sự muốn hủy nhận ủy thác án này? ');"
                                                CommandName="btnHuyNhan" CommandArgument='<%#Eval("ID") %>' ></asp:Button>         
                                            <asp:Button ID="btnTraLaiBiAn" runat="server" Text="Trả lại bị án" OnClick="btnTraLaiBiAnOnClick" CssClass="buttonchitiet" CausesValidation="false"
                                                OnClientClick="return confirm('Bạn thực sự muốn trả lại ủy thác bị án này? ');"
                                                CommandName="btnTraLaiBiAn" CommandArgument='<%#Eval("ID") %>' ></asp:Button>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                 <%--   <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thao tác</HeaderTemplate>
                                        <ItemTemplate>
                                            <div class="header_cell">
                                                <asp:LinkButton ID="lbtSua" runat="server" Text="Sửa" CausesValidation="false" OnClick="btnSuaOnClick"
                                                    CommandName="sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                &nbsp;&nbsp;
                                             <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false"
                                                 Text="Xóa" ForeColor="#0e7eee"
                                                 CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"
                                                 OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>--%>
                                </Columns>
                                <HeaderStyle CssClass="header"></HeaderStyle>
                                <ItemStyle CssClass="chan"></ItemStyle>
                                <PagerStyle Visible="false"></PagerStyle>
                            </asp:DataGrid>

                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>

                            <!--------------------------------------->
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                    <asp:DropDownList ID="ddlPageCount2" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script>
        function pageLoad(sender, args) {
            $(function () {

                var urldm_toaan = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/SearchTopToaAn") %>';
                $("[id$=txtToaAnUyThac]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldm_toaan, data: "{ 'textsearch': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                            success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                        });
                    },
                    select: function (e, i) { $("[id$=hddToaAnUyThacID]").val(i.item.val); }, minLength: 1
                });
            });


        }
    </script>
</asp:Content>
