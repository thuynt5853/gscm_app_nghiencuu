<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="GiaoNhanDon.aspx.cs" Inherits="WEB.GSTP.QLAN.HOAGIAI.GiaoNhanDon" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style type="text/css">
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

        .d-file-upload div input {
            border: solid 1px #cccccc;
            border-radius: 4px;
            height: 20px;
            font-size: 12px;
            font-family: Arial, Helvetica, sans-serif;
            color: #044271;
            padding: 2px 3px;
            text-indent: 3px;
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

        .d-pt-tb {
            padding-top: 20px;
        }
        /*        table, th, td {
  border: 1px solid;
}*/
    </style>
    <script src="../../../UI/js/Common.js"></script>
    <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddLoaiAn" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
    <asp:HiddenField ID="hddPageSize" Value="20" runat="server" />
    <asp:HiddenField ID="hddHoaGiaiId" Value="1" runat="server" />
    <asp:HiddenField ID="hddVuViecId" Value="1" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Thông tin giao nhận đơn <%=hoagiaitext%></h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td class="Col1">Ngày giao<span class="batbuoc">(*)</span></td>
                            <td class="Col2">
                                <asp:TextBox ID="txtNgayGiao" runat="server"
                                    AutoPostBack="True" CssClass="user txtCalendar d-validator-required" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="v_CalendarExtender" runat="server" TargetControlID="txtNgayGiao" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayGiao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayGiao" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                            </td>
                            <%--<td class="Col3">Ngày giao thực tế<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtNgayGiaoThuc" runat="server" CssClass="user txtCalendar"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayGiaoThuc"
                                    Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayGiaoThuc"
                                    Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>--%>
                        </tr>
                        <tr>
                            <td class="Col1">Người giao<span class="batbuoc">(*)</span></td>
                            <td colspan="3">
                                <asp:DropDownList ID="ddlNguoiGiao" CssClass="chosen-select Drop1Col d-validator-required" runat="server" AutoPostBack="True">
                                </asp:DropDownList>
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td class="Col1">Ngày nhận<span class="batbuoc">(*)</span></td>
                            <td class="Col2">
                                <asp:TextBox ID="txtNgayNhan" runat="server" CssClass="user txtCalendar d-validator-required"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayNhan"
                                    Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgayNhan"
                                    Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <td class="Col3">Ngày lập biên bản<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtNgayLapBienBan" runat="server" CssClass="user txtCalendar d-validator-required"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayLapBienBan"
                                    Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayLapBienBan"
                                    Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td class="Col1">Người nhận<span class="batbuoc">(*)</span></td>
                            <td class="Col2">
                                <asp:DropDownList ID="ddlNguoiNhan" CssClass="chosen-select Drop1Col d-validator-required" runat="server" AutoPostBack="True">
                                </asp:DropDownList>
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td class="Col1">Trạng thái nhận<span class="batbuoc">(*)</span></td>
                            <td class="Col2">
                                <asp:DropDownList ID="ddlTrangThai" CssClass="chosen-select Drop1Col d-validator-required" runat="server" AutoPostBack="True">
                                    <asp:ListItem Value="1" Text="Đã nhận"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Không nhận"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="Bảo lưu"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td class="Col1">Ghi chú</td>
                            <td colspan="3" class="Col2">
                                <asp:TextBox ID="txtGhiChu" CssClass="user" runat="server" Width="660px" MaxLength="500" TextMode="MultiLine" Rows="2"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="1000">
                                <asp:Label runat="server" CssClass="d-thongbao d-pt-tb" ID="lblThongBao" ForeColor="Red"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2" align="center">
                            <asp:Button ID="btnUpdate" runat="server" CssClass="buttoninput"
                                Text="Lưu" OnClick="btnUpdate_Click" OnClientClick="return validate()" />

                            <asp:Button ID="btnLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div>
                                <asp:HiddenField ID="hddid" runat="server" Value="0" />
                            </div>

                            <asp:Panel runat="server" ID="pndata">
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:TemplateColumn HeaderStyle-Width="45px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                TT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Container.DataSetIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                        <asp:BoundColumn DataField="NGAYGIAO" HeaderText="Ngày giao" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Người giao
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("NGUOIGIAO") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <%--<asp:BoundColumn DataField="NGAYGIAOTHUC" HeaderText="Ngày giao thực tế" HeaderStyle-Width="200px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>--%>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Người nhận
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("NGUOINHAN") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="NGAYNHAN" HeaderText="Ngày nhận" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Ghi chú
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("GHICHU") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Trạng thái
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TRANGTHAI_TEXT") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="NGUOITAO" HeaderText="Người tạo" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
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
    <script type="text/javascript">
        function ThongBaoOnHide() {
            $(".d-thongbao").delay(3000).fadeOut(300);
            //validate();
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

        function Setfocus(controlid) {
            var ctrl = document.getElementById(controlid);
            ctrl.focus();
        }
    </script>
</asp:Content>
