<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master"
    AutoEventWireup="true" CodeBehind="DongBoDLDCQG.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.DongBo.DongBoDLDCQG" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="modal.css" rel="stylesheet" />
    <style>
        .btn-break {
            display: block;
            margin-bottom: 8px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Tìm kiếm</h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">

                                        <tr>
                                            <td>Mã vụ án</td>
                                            <td>
                                                <asp:TextBox ID="txtMaVuAn" CssClass="user" runat="server" Width="240px" MaxLength="50"></asp:TextBox>
                                            </td>
                                            <td>Cấp xét xử</td>
                                            <td>
                                                <asp:DropDownList ID="dropCapxx" CssClass="chosen-select" runat="server" Width="240px"
                                                    AutoPostBack="True" OnSelectedIndexChanged="dropCapxx_SelectedIndexChanged">
                                                </asp:DropDownList>
                                            </td>
                                            <td>Tòa xx
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="DropToaAn" CssClass="chosen-select" runat="server" Width="240px"></asp:DropDownList>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td style="width: 80px;">Tên vụ án</td>
                                            <td>
                                                <div style="float: left;">
                                                    <asp:TextBox ID="txtTenVuAn" CssClass="user" runat="server" Width="240px"></asp:TextBox>
                                                </div>
                                                <div style="float: left; margin-left: 10px;">
                                                    <span style="float: left; line-height: 25px; margin-right: 5px;"></span>

                                                </div>
                                            </td>
                                            <td>Loại quyết định</td>
                                            <td>
                                                <asp:DropDownList ID="ddlLoaiQuyetDinh" CssClass="chosen-select" runat="server" Width="240px">
                                                    <asp:ListItem Value="1" Text="Quyết định thi hành án" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Quyết định xóa án tích"></asp:ListItem>
                                                    <asp:ListItem Value="939" Text="Quyết định tạm đình chỉ chấp hành phạt tù"></asp:ListItem>
                                                    <asp:ListItem Value="2638" Text="Quyết định tha tù trước thời hạn có điều kiện"></asp:ListItem>
                                                    <%--<asp:ListItem Value="943" Text="Quyết định xóa án tích"></asp:ListItem>--%>
                                                    <asp:ListItem Value="938" Text="Quyết định hoãn thi hành hình phạt tù"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td>Tội danh</td>
                                            <td>
                                                <asp:TextBox ID="txtToidanh" CssClass="user"
                                                    runat="server" Width="240px" MaxLength="50"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>

                                            <td>Bị án</td>
                                            <td>
                                                <asp:TextBox ID="txtBican" CssClass="user" runat="server" Width="240px"></asp:TextBox>
                                            </td>
                                            <td>Số CCCD</td>
                                            <td>
                                                <asp:TextBox ID="txtCCCD" CssClass="user"
                                                    runat="server" Width="240px" MaxLength="50"></asp:TextBox>
                                            </td>
                                            <td>Số quyết định</td>
                                            <td>
                                                <asp:TextBox ID="txtSoQuyetDinh" CssClass="user" runat="server"
                                                    Width="240px" MaxLength="50"></asp:TextBox></td>
                                        </tr>

                                        <tr>


                                            <td>Từ ngày</td>
                                            <td>
                                                <div style="float: left;">
                                                    <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" MaxLength="10" Width="240px"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server"
                                                        TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server"
                                                        TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                                        ErrorTooltipEnabled="true" />
                                                </div>

                                            </td>
                                            <td>Đến ngày</td>
                                            <td>
                                                <div style="float: left;">

                                                    <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" MaxLength="10" Width="240px"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server"
                                                        TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server"
                                                        TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                                        ErrorTooltipEnabled="true" />
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Trạng thái đồng bộ</td>
                                            <td>
                                                <asp:DropDownList ID="ddlTrangthaiDongBo" CssClass="chosen-select" runat="server" Width="240px" AutoPostBack="True" OnSelectedIndexChanged="ddlTrangthaiDongBo_SelectedIndexChanged">
                                                    <asp:ListItem Value="0" Text="Chưa đồng bộ" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Đã đồng bộ"></asp:ListItem>
                                                    <asp:ListItem Value="3" Text="Đang đồng bộ"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Bị thu hồi"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td>Thẩm phán</td>
                                            <td>
                                                <asp:DropDownList ID="ddlThamphan" CssClass="chosen-select" runat="server" Width="240px"></asp:DropDownList>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />

                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />

                            <asp:Button ID="btnGuiDLC" runat="server" CssClass="buttoninput" Text="Đồng bộ dữ liệu" OnClick="btnDongBoDuLieu_Click" OnClientClick="return confirm('Bạn có chắc chắn muốn đồng bộ dữ liệu không? Bạn phải chịu trách nhiệm về hành động này');" />

                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="left">
                            <asp:Panel ID="pn_thuhoi" runat="server" Visible="false">
                                <div>
                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px; padding-top: 8px; font-weight: bold;">Lý do thu hồi</div>
                                    <div style="float: left; margin-right: 10px; padding-top: 3px">
                                        <asp:TextBox ID="txtLyDoThuHoi" CssClass="user" runat="server" Width="240px" placeholder="Nhập lý do thu hồi..."></asp:TextBox>
                                    </div>
                                    <div style="float: left; padding-bottom: 5px;">
                                        <asp:Button ID="btnThuHoi" runat="server" CssClass="buttoninput" Text="Thu hồi" OnClick="btnThuHoi_Click" OnClientClick="return validateThuHoi();" />
                                    </div>
                                </div>
                            </asp:Panel>

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

                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound"
                                ItemStyle-CssClass="chan" Width="100%">
                                <Columns>
                                    <asp:TemplateColumn HeaderStyle-Width="20px" HeaderText="">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkChon" runat="server" AutoPostBack="true"
                                                OnCheckedChanged="chkChon_CheckedChanged"
                                                ToolTip='<%#Eval("ID") +","+Eval("LoaiQDID")+","+Eval("KHOBIAN_QUYETDINH_ID")+","+Eval("TRANGTHAIQD")%>' />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="15px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>STT</HeaderTemplate>
                                        <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Tên bị án - Tội danh</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("HOTENBIAN_TOIDANH") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Tên vụ án</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("TENVUAN") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Số bản án/QĐ</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("SOBANAN") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Ngày bản án/QĐ</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("NGAYBANAN") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Hình phạt tổng hợp</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("HINHPHAT_TONGHOP") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Số thụ lý - Ngày thụ lý THA</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("THA_SOTHULY_NGAYTHULY") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Số QĐ Thi hành án</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("SoQdinh") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Trạng thái đồng bộ</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("TRANGTHAIQDNAME") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thao tác</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="LinkButtonXemLichSu" runat="server" CausesValidation="false" Text="Xem lịch sử" Font-Bold="true" ForeColor="#0e7eee" CommandName="View"
                                                CommandArgument='<%#Eval("ID") +","+Eval("LoaiQDID")+","+Eval("KHOBIAN_QUYETDINH_ID")+","+Eval("TRANGTHAIQD")%>' ToolTip="Xem lịch sử" CssClass="btn-break"></asp:LinkButton>
                                            <asp:LinkButton ID="LinkButtonXemGuiLai" runat="server" CausesValidation="false" Text="Gửi lại" Font-Bold="true" ForeColor="#0e7eee" CommandName="GuiLai" CommandArgument='<%#Eval("ID") +","+Eval("LoaiQDID")+","+Eval("KHOBIAN_QUYETDINH_ID")+","+Eval("TRANGTHAIQD")%>'
                                                ToolTip="Gửi lại" OnClientClick="return confirm('Bạn có chắc muốn Gửi lại không?');" CssClass="btn-break"></asp:LinkButton>

                                            <asp:LinkButton ID="LinkButtonHuyChuyen" runat="server" Text="Hủy chuyển"
                                                CommandName="HuyChuyen"
                                                CommandArgument='<%#Eval("ID") +","+Eval("LoaiQDID")+","+Eval("KHOBIAN_QUYETDINH_ID")+","+Eval("TRANGTHAIQD")%>'
                                                OnClientClick="return confirm('Bạn có chắc muốn hủy chuyển không?');" CssClass="btn-break" />

                                            <i style='margin-right: 3px;'>Tài khoản gửi:</i><%#Eval("TAIKHOANTAO")%>
                                            <br />
                                            <i style='margin-right: 3px;'>Ngày gửi:</i><%#Eval("NGAYTAO")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                </Columns>
                                <HeaderStyle CssClass="header"></HeaderStyle>
                                <ItemStyle CssClass="chan"></ItemStyle>
                                <PagerStyle Visible="false"></PagerStyle>
                            </asp:DataGrid>

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
        function validateThuHoi() {
            var txtLyDoThuHoi = document.getElementById('<%=txtLyDoThuHoi.ClientID%>');
            if (txtLyDoThuHoi.value == '') {
                alert('Chưa nhập Lý do thu hồi. Hãy nhập lại!');
                txtLyDoThuHoi.focus();
                return false;
            }

            return confirm('Bạn có chắc muốn thu hồi dữ liệu không?');;

        }
        function pageLoad(sender, args) {

            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>


</asp:Content>
