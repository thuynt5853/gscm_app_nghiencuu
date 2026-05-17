<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="CapNhatKQDNKN.aspx.cs" Inherits="WEB.GSTP.QLAN.HOAGIAI.CapNhatKQDNKN" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style type="text/css">
        .tb-dnkn td {
            border: 0px;
        }

        .d-not-vaild {
            border: solid 1px red !important;
        }

        .d-validator-message {
            color: red;
        }

        .mt-2 {
            margin-top: 5px;
        }

        .Col1 {
            width: 125px;
        }

        .Col2 {
            width: 260px;
        }

        .Col3 {
            width: 145px;
        }

        .Col4 {
            width: 250px;
        }

        .Drop1Col {
            width: 250px;
        }

        .Drop3Col {
            width: 668px;
        }

        .txtCalendar {
            width: 110px;
        }
    </style>
    <script src="../../../UI/js/Common.js"></script>
    <asp:Panel ID="pnDanhsach" runat="server">
        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <asp:HiddenField ID="hddTPCT" Value="0" runat="server" />
        <asp:HiddenField ID="hddTPTV1" Value="0" runat="server" />
        <asp:HiddenField ID="hddTPTV2" Value="0" runat="server" />
        <asp:HiddenField ID="hddBM" Value="0" runat="server" />
        <div class="box">
            <div class="box_nd">
                <div class="truong">
                    <table class="table1">
                        <tr>
                            <td>
                                <div class="boxchung">
                                    <h4 class="tleboxchung">Tìm kiếm vụ việc</h4>
                                    <div class="boder" style="padding: 10px;">
                                        <table class="table1">
                                            <tr>
                                                <td style="width: 105px;">Mã vụ việc</td>
                                                <td style="width: 260px;">
                                                    <asp:TextBox ID="txtMaVuViec" CssClass="user" runat="server" Width="242px" MaxLength="50"></asp:TextBox>
                                                </td>
                                                <td style="width: 62px;">Tên vụ việc</td>
                                                <td>
                                                    <asp:TextBox ID="txtTenVuViec" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Ngày đề nghị/kiến nghị từ</td>
                                                <td>
                                                    <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                </td>
                                                <td>Đến ngày</td>
                                                <td>
                                                    <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtDenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Trạng thái</td>
                                                <td colspan="3">
                                                    <asp:RadioButtonList ID="rdbTrangthai" runat="server" RepeatDirection="Horizontal">
                                                        <asp:ListItem Value="0" Text="Chưa giải quyết" Selected="True"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đã giải quyết"></asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: center;">
                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="cmdTimkiem_Click" OnClientClick="return validateSearch();" />
                                <asp:Button ID="cmdGiaiQuyet" runat="server" CssClass="buttoninput" Text="Giải quyết" OnClick="cmdGiaiQuyet_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                <div class="phantrang" id="ptT" runat="server">
                                    <div class="sobanghi">
                                        <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
                                        <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                            OnClick="lbTBack_Click">
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                            Text="1" OnClick="lbTFirst_Click">
                                        </asp:LinkButton>
                                        <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                            Text="2" OnClick="lbTStep_Click">
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                            Text="3" OnClick="lbTStep_Click">
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                            Text="4" OnClick="lbTStep_Click">
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                            Text="5" OnClick="lbTStep_Click">
                                        </asp:LinkButton>
                                        <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                            Text="100" OnClick="lbTLast_Click">
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                            OnClick="lbTNext_Click">
                                        </asp:LinkButton>
                                    </div>
                                </div>
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4" PageSize="10" AllowPaging="True" GridLines="None"
                                    PagerStyle-Mode="NumericPages" CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="VUVIECID" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>TT</HeaderTemplate>
                                            <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="55px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Chọn</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkChon" AutoPostBack="true" ToolTip='<%#Eval("ID")%>' OnCheckedChanged="chkChon_CheckedChanged" runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="130px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Mã vụ việc
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:Label ID="lblTBMaVuViec" runat="server" Text='<%# Eval("MAVUVIEC") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tên vụ việc
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:Label ID="lblTBTenVuViec" runat="server" Text='<%# Eval("TENVUVIEC") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="TEN" HeaderText="Tòa án" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="THONGTIN" HeaderText="Ngày đề nghị/ kiến nghị" HeaderStyle-Width="180px" ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="KETQUA" HeaderText="Kết quả" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="100px"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lblGiaiQuyet" runat="server" Text="Giải quyết" CausesValidation="false" CommandName="GiaiQuyet" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Container.DataSetIndex %>' CssClass="pl-3"></asp:LinkButton>
                                                <%--                                                <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');">
                                                </asp:LinkButton>--%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                                <div class="phantrang" id="ptB" runat="server">
                                    <div class="sobanghi">
                                        <asp:HiddenField ID="hdicha" runat="server" />
                                        <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
                                        <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                            OnClick="lbTBack_Click">
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                            Text="1" OnClick="lbTFirst_Click">
                                        </asp:LinkButton>
                                        <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                            Text="2" OnClick="lbTStep_Click">
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                            Text="3" OnClick="lbTStep_Click">
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                            Text="4" OnClick="lbTStep_Click">
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                            Text="5" OnClick="lbTStep_Click">
                                        </asp:LinkButton>
                                        <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                            Text="100" OnClick="lbTLast_Click">
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                            OnClick="lbTNext_Click">
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnCapnhat" runat="server" Visible="false">
        <asp:HiddenField ID="hddVuViecID" runat="server" Value="0" />
        <asp:HiddenField ID="hddHoaGiaiID" runat="server" Value="0" />
        <asp:HiddenField ID="hddDeNghi" Value="1" runat="server" />
        <asp:HiddenField ID="hddLoaiAn" Value="1" runat="server" />
        <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
        <div class="box">
            <div class="box_nd">
                <div class="boxchung">
                    <h4 class="tleboxchung">
                        <asp:Label runat="server" ID="Label2" Text="Thông tin vụ việc đang xử lý"></asp:Label>
                    </h4>
                    <div class="boder" style="padding: 10px;">
                        <div class="vuanghim_info" style="float: none">
                            Mã vụ việc:
                            <asp:Label runat="server" ID="lblMaVuViec"></asp:Label>
                            <br>
                            Tên vụ việc:
                            <asp:Label runat="server" ID="lblTenVuViec"></asp:Label>
                        </div>
                    </div>
                </div>
                <div class="boxchung">
                    <h4 class="tleboxchung">
                        <asp:Label runat="server" ID="lbTitle" Text="Thông tin thụ lý đề nghị/kiến nghị"></asp:Label>
                    </h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <asp:Panel ID="pnlThuLy" runat="server" Enabled="true">
                                <asp:TextBox ID="txtKetQuaDNKNID" runat="server" Visible="false" />
                                <tr>
                                    <td class="Col1">Ngày giao<span class="batbuoc">(*)</span></td>
                                    <td class="Col2">
                                        <asp:TextBox ID="txtNgayGiao" runat="server"
                                            AutoPostBack="False" CssClass="user txtCalendar d-validator-required" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="txtNgayGiaoCalendarExtender" runat="server" TargetControlID="txtNgayGiao" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="txtNgayGiaoMaskedEditExtender" runat="server" TargetControlID="txtNgayGiao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                    <td class="Col3">Ngày nhận<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayNhan" runat="server"
                                            AutoPostBack="False" CssClass="user txtCalendar d-validator-required" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayNhan" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayNhan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Col1">Ngày thụ lý<span class="batbuoc">(*)</span></td>
                                    <td class="Col2">
                                        <asp:TextBox ID="txtNgayThuLy" runat="server" CssClass="user txtCalendar d-validator-required"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayThuLy"
                                            Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgayThuLy"
                                            Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                    <td class="Col3">Số thụ lý<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtSoThuLy" CssClass="user d-validator-required" runat="server" Width="242px"></asp:TextBox>
                                    </td>
                                </tr>

                                <tr>
                                    <td style="padding-top: 10px"></td>
                                </tr>
                            </asp:Panel>
                            <tr>
                                <td colspan="5" align="center">
                                    <asp:Button ID="btnUpdateTL" runat="server" CssClass="buttoninput" OnClick="btnUpdate_Click"
                                        Text="Lưu" OnClientClick="return validate()" />
                                    <asp:Button ID="btnEditTL" runat="server" CssClass="buttoninput" Text="Sửa" OnClick="btnEditTL_Click" />
                                    <asp:Button ID="btnDeleteTL" runat="server" CssClass="buttoninput" Text="Xóa" OnClick="btnDeleteTL_Click" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');" />
                                </td>
                            </tr>



                            <tr>
                                <td colspan="1000" style="padding-top: 20px">
                                    <asp:Label runat="server" CssClass="d-thongbao" ID="lblThongBao" ForeColor="Red"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

                <div class="boxchung">
                    <h4 class="tleboxchung">
                        <asp:Label runat="server" ID="lblTitle" Text="Thông tin giải quyết đề nghị/kiến nghị"></asp:Label>
                    </h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <asp:Panel ID="pnlGiaiQuyet" runat="server" Enabled="false">
                                <tr>
                                    <td class="Col1">Thẩm phán<span class="batbuoc">(*)</span></td>
                                    <td class="Col2">
                                        <asp:DropDownList ID="ddlThamphan" AutoPostBack="False" CssClass="user chosen-select Drop1Col" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                    <td class="Col3">Toà án giải quyết</td>
                                    <td>
                                        <asp:DropDownList ID="ddlToaAnTrucThuoc" Enabled="False" CssClass="user chosen-select Drop1Col" runat="server"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Col1">Kết quả giải quyết đề nghị/ kiến nghị<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddlKetQuaDNKN" CssClass="chosen-select Drop3Col" runat="server" AutoPostBack="False">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Col1">Ngày quyết định<span class="batbuoc">(*)</span></td>
                                    <td class="Col2">
                                        <asp:TextBox ID="txtNgayQD" runat="server" CssClass="user txtCalendar"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayQD"
                                            Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayQD"
                                            Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                    <td class="Col3">Số quyết định<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtSoQD" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-top: 10px"></td>
                                </tr>
                            </asp:Panel>
                            <tr>
                                <td colspan="5" align="center">
                                    <asp:Button ID="btnUpdateKQ" runat="server" CssClass="buttoninput" OnClick="btnUpdateKQ_Click"
                                        Text="Lưu" OnClientClick="return validate()" />
                                    <asp:Button ID="btnEditKQ" runat="server" CssClass="buttoninput" Text="Sửa" OnClick="btnEditKQ_Click" />
                                    <asp:Button ID="btnDeleteKQ" runat="server" CssClass="buttoninput" Text="Xóa" OnClick="btnDeleteKQ_Click" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="1000" style="padding-top: 20px">
                                    <asp:Label runat="server" CssClass="d-thongbao" ID="lblThongBaoKQ" ForeColor="Red"></asp:Label>
                                </td>
                            </tr>

                        </table>
                    </div>
                </div>
                <div class="truong">
                    <table class="table1">
                        <tr>
                            <td colspan="2" align="center">
                                <%--<asp:Button ID="btnUpdate" runat="server" CssClass="buttoninput" OnClick="btnUpdate_Click"
                                    Text="Lưu" OnClientClick="return validate()" />--%>
                                <%--<asp:Button ID="btnLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />--%>
                                <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdQuaylai_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div>
                                    <asp:HiddenField ID="hddid" runat="server" Value="0" />
                                    <asp:Label runat="server" ID="Label1" ForeColor="Red"></asp:Label>
                                </div>

                                <asp:Panel runat="server" ID="pndata" Visible="true">
                                    <asp:DataGrid ID="dgKQ" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                        PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                        CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                        ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgList_ItemCommandKQ" OnItemDataBound="dgList_ItemDataBoundKQ">
                                        <Columns>
                                            <asp:TemplateColumn HeaderStyle-Width="45px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    TT
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%# Container.DataSetIndex + 1 %>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>

                                            <asp:BoundColumn DataField="KETQUA_TEXT" HeaderText="Kết quả giải quyết đề nghị/ kiến nghị" HeaderStyle-Width="300px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="THAMPHAN_HOTEN" HeaderText="Thẩm phán" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="NGAYGIAO" HeaderText="Ngày giao" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="NGAYNHAN" HeaderText="Ngày nhận" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>

                                            <asp:BoundColumn DataField="SOQUYETDINH" HeaderText="Số QĐ" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="NGAYQUYETDINH" HeaderText="Ngày QĐ" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="TOAAN_TRUC_THUOC" HeaderText="Tòa án trực thuộc" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    Thao tác
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lblSua" runat="server" Text="Chi tiết" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                        CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                    &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                        </Columns>
                                        <HeaderStyle CssClass="header"></HeaderStyle>
                                        <ItemStyle CssClass="chan"></ItemStyle>
                                        <PagerStyle Visible="false"></PagerStyle>
                                    </asp:DataGrid>
                                </asp:Panel>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </asp:Panel>
    <script type="text/javascript">
        function validateSearch() {
            var txtTuNgay = document.getElementById('<%=txtTuNgay.ClientID%>');
            var lengthTuNgay = txtTuNgay.value.trim().length;
            var TuNgay;
            if (lengthTuNgay > 0) {
                var arr = txtTuNgay.value.split('/');
                TuNgay = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (TuNgay.toString() == "NaN" || TuNgay.toString() == "Invalid Date") {
                    alert('Bạn phải nhập kháng cáo từ ngày theo định dạng (dd/MM/yyyy).');
                    txtTuNgay.focus();
                    return false;
                }
            }
            var txtDenNgay = document.getElementById('<%=txtDenNgay.ClientID%>');
            var lengthDenNgay = txtDenNgay.value.trim().length;
            var DenNgay;
            if (lengthDenNgay > 0) {
                var arr = txtDenNgay.value.split('/');
                DenNgay = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (DenNgay.toString() == "NaN" || DenNgay.toString() == "Invalid Date") {
                    alert('Bạn phải nhập kháng cáo đến ngày theo định dạng (dd/MM/yyyy).');
                    txtDenNgay.focus();
                    return false;
                }
            }
            if (lengthTuNgay > 0 && lengthDenNgay > 0 && TuNgay > DenNgay) {
                alert('Ngày kháng cáo từ ngày phải nhỏ hơn đến ngày.');
                txtDenNgay.focus();
                return false;
            }
            return true;
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
            //CheckKyso();
        }
        function validate() {
            let isPass = true;
            let countRun = 0;
            let total = $(".d-validator-required").length;
            $(".d-validator-required").each(function (index, element) {
                let isVaild = false;
                let type = $(this)[0].localName;
                let value = $(this).val();
                switch (type) {
                    case 'select':
                        if (value == null || value == "" || value == 0) {
                            isVaild = false;
                        } else {
                            isVaild = true;
                        }
                        break;
                    case 'table':
                        //radio
                        $(this).find("input:checked").each(function (index, element) {
                            value = $(element).val();
                            return;
                        });
                        if (value == null || value == "") {
                            isVaild = false;
                        } else {
                            isVaild = true;
                        }
                        break;
                    default:
                        if (value == null || value == "") {
                            isVaild = false;
                        } else {
                            isVaild = true;
                        }
                        break;
                }
                if (!isVaild) {
                    let message = $(this).parent().find('.d-validator-message');
                    if (message.length == 0) {
                        $(this).parent().append(`<span class="d-validator-message mt-1"></span>`);
                        message = $(this).parent().find('.d-validator-message');
                    }
                    message.text("Không được để trống");
                    message.css("display", "unset")
                    message.css("visibility", "inherit")
                    let inputClass = $(this);
                    switch (type) {
                        case 'select':
                            inputClass = $(this).parent().find('a.chosen-single');
                            break;
                        default:
                            break;
                    }
                    inputClass.addClass("d-not-vaild");
                    isPass = false;
                }
                countRun++;
            });
            while (countRun < total)
                break;
            if (isPass == false)
                alert("Hãy điền đầy đủ thông tin");
            return isPass;
        }
        $(document).on('blur', '.d-validator-required', function (event) {
            $(this).parent().find('.d-validator-message').css("display", "none")
            let type = $(this)[0].localName;
            let inputClass = $(this);
            switch (type) {
                case 'select':
                    inputClass = $(this).parent().find('a.chosen-single');
                    break;
                default:
                    break;
            }
            inputClass.removeClass("d-not-vaild");
        });
    </script>
</asp:Content>
