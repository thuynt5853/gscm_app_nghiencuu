<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="GhiNhanKetQua.aspx.cs" Inherits="WEB.GSTP.QLAN.HOAGIAI.GhiNhanKetQua" %>

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
    <asp:HiddenField ID="hddFileid" Value="0" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Phiên họp ghi nhận kết quả <%=hoagiaitext%></h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <asp:TextBox ID="txtKetQuaHoaGiaiID" runat="server" Visible="false" />
                        <tr>
                            <td class="Col1">Ngày diễn ra phiên <%=hoagiaitext%><span class="batbuoc">(*)</span></td>
                            <td class="Col2">
                                <asp:TextBox ID="txtNgayHoaGiai" runat="server"
                                    AutoPostBack="False" CssClass="user txtCalendar d-validator-required" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtNgayHoaGiai_CalendarExtender" runat="server" TargetControlID="txtNgayHoaGiai" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayHoaGiai" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator1" CssClass="d-validator-message" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayHoaGiai" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                            </td>
                            <td class="Col3">Địa điểm</td>
                            <td>
                                <asp:TextBox ID="txtDiaDiem" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="Col1">Kết quả <%=hoagiaitext%><span class="batbuoc">(*)</span></td>
                            <td colspan="3">
                                <asp:DropDownList ID="dllKetQua" CssClass="user chosen-select Drop3Col d-validator-required" runat="server" AutoPostBack="True" OnSelectedIndexChanged="dllKetQua_SelectedIndexChanged">
                                </asp:DropDownList>
                                <span class="d-validator-message" style="color: red; margin-left: 15px;"></span>
                            </td>
                        </tr>
                        <asp:Panel ID="pnYeuCauQuyetDinh" runat="server" Visible="false">
                            <tr>
                                <td class="Col1">Yêu cầu quyết định công nhận <%=hoagiaitext%> thành</td>
                                <td colspan="3">
                                    <asp:DropDownList ID="ddlYeuCauQuyetDinh" CssClass="user chosen-select Drop3Col" runat="server" AutoPostBack="False">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </asp:Panel>
                        <asp:Panel ID="pnLyDoHoaGiaiKhongThanh" runat="server" Visible="false">
                            <tr>
                                <td class="Col1">Lý do <%=hoagiaitext%> không thành</td>
                                <td colspan="3">
                                    <asp:DropDownList ID="ddlLyDoHoaGiaiKhongThanh" CssClass="user chosen-select Drop3Col" runat="server" AutoPostBack="True">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </asp:Panel>
                        <asp:Panel ID="pnLyDoHoan" runat="server" Visible="false">
                            <tr>
                                <td class="Col1">Lý do hoãn</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtLyDoHoan" CssClass="user" runat="server" Width="660px" MaxLength="500" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                </td>
                            </tr>
                        </asp:Panel>
                        <tr>
                            <td class="Col1">Người ký<span class="batbuoc">(*)</span></td>
                            <td class="Col2">
                                <%--                                <asp:TextBox ID="txtNguoiKy" CssClass="user d-validator-required" Enabled="false" runat="server" Width="242px"></asp:TextBox>
                                <span class="d-validator-message mt-1"></span>--%>
                                <asp:DropDownList ID="ddlNguoiKy" CssClass="chosen-select Drop1Col d-validator-required" runat="server" AutoPostBack="True">
                                </asp:DropDownList>
                            </td>
                            <%--                            <td class="Col3">Chức vụ<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtChuVu" CssClass="user d-validator-required" Enabled="false" runat="server" Width="242px"></asp:TextBox>
                                <span class="d-validator-message mt-1"></span>
                            </td>--%>
                        </tr>
                        <asp:Panel ID="pnQuyetDinh" runat="server" Visible="false">
                            <tr>
                                <td class="Col1">Ngày quyết định<span class="batbuoc">(*)</span></td>
                                <td class="Col2">
                                    <asp:TextBox ID="txtNgayQD" runat="server" CssClass="user txtCalendar d-validator-required"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayQD"
                                        Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayQD"
                                        Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td class="Col3">Số quyết định<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtSoQD" CssClass="user d-validator-required" runat="server" Width="242px"></asp:TextBox>
                                </td>
                            </tr>
                        </asp:Panel>
                        <asp:Panel ID="pnNgayVaSoThongBao" runat="server" Visible="false">
                            <tr>
                                <td class="Col1">Ngày ra thông báo<asp:Literal ID="ltNgayRaThongBao" runat="server"></asp:Literal></td>
                                <td class="Col2">
                                    <asp:TextBox ID="txtNgayThongBao" runat="server" CssClass="user txtCalendar"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayThongBao"
                                        Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayThongBao"
                                        Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td class="Col3">Số thông báo<asp:Literal ID="ltSoThongBao" runat="server"></asp:Literal></td>
                                <td>
                                    <asp:TextBox ID="txtThongBao" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                </td>
                            </tr>
                        </asp:Panel>
                        <asp:Panel ID="pnNgayLapBienBan" runat="server" Visible="false">
                            <tr>
                                <td class="Col1">Ngày lập biên bản</td>
                                <td class="Col2">
                                    <asp:TextBox ID="txtNgayLapbb" runat="server" CssClass="user txtCalendar"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayLapbb"
                                        Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgayLapbb"
                                        Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td></td>
                                <td></td>

                            </tr>
                        </asp:Panel>
                        <tr>
                            <asp:Panel ID="pnZonekythuong" runat="server">
                                <td class="Col1">Tệp đính kèm</td>
                                <td colspan="3">
                                    <asp:HiddenField ID="hddFileKySo" runat="server" Value="" />
                                    <asp:HiddenField ID="hddSessionID" runat="server" />
                                    <asp:HiddenField ID="hddURLKS" runat="server" />
                                    <asp:HiddenField ID="hddFilePath" runat="server" Value="" />
                                    <div id="zonekythuong" style="margin-top: 10px; width: 80%;">
                                        <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                            ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" CssClass="d-file-upload" />
                                        <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                    </div>

                                    <div style="display: none">
                                        <asp:Button ID="cmdThemFileTL" runat="server"
                                            Text="Them tai lieu" />
                                    </div>
                                    <asp:LinkButton ID="lbtDownload" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownload_Click"></asp:LinkButton>
                                </td>
                            </asp:Panel>
                        </tr>
                        <tr>
                            <td colspan="1000" style="padding-top: 20px">
                                <asp:Label runat="server" CssClass="d-thongbao" ID="lblThongBao" ForeColor="Red"></asp:Label>
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

                            <asp:Panel runat="server" ID="pndata" Visible="true">

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

                                        <asp:BoundColumn DataField="NGAYHOAGIAI" HeaderText="Ngày diễn ra phiên <%=hoagiaitext%>" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Kết quả <%=hoagiaitext%>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("KETQUATXT") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="SOTHONGBAO" HeaderText="Số TB" HeaderStyle-Width="50px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYTHONGBAO" HeaderText="Ngày TB/ Ngày lập biên bản" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGUOIKY" HeaderText="Người ký" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Người tạo
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("NGUOITAO") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <%--              <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tệp đính kèm
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("NGUOITAO") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>--%>
                                        <%--Visible="<%# Eval("FILESID") != null %>"--%>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                            <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:ImageButton ID="lblDownload" ImageUrl="~/UI/img/ghim.png" runat="server" CausesValidation="false" CommandName="Download"
                                                    CommandArgument='<%#Eval("FILESID") %>' Visible="true" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
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
    <script>
        //ThongBaoOnHide();
        function ThongBaoOnHide() {
            $(".d-thongbao").delay(3000).fadeOut(300);
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
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
