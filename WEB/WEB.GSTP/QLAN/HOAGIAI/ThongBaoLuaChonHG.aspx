<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="ThongBaoLuaChonHG.aspx.cs" Inherits="WEB.GSTP.QLAN.HOAGIAI.ThongBaoLuaChonHG" %>


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
        /*        table, th, td {
  border: 1px solid;
}*/
    </style>
    <script src="../../../UI/js/Common.js"></script>
    <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddLoaiAn" Value="0" runat="server" />
    <asp:HiddenField ID="hddHoaGiaiId" Value="0" runat="server" />
    <asp:HiddenField ID="hddFileid" Value="0" runat="server" />
    <asp:HiddenField ID="hddVuViecId" Value="0" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
    <asp:HiddenField ID="hddlstDuongSuId" runat="server" Value="" />
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">
                    <asp:Label runat="server" ID="lbTitle">Thông báo <%=hoagiaitext%></asp:Label>
                </h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td class="Col1">Loại thông báo<span class="batbuoc">(*)</span></td>
                            <td colspan="3">
                                <asp:DropDownList ID="dllLoaiThongBao" CssClass="user chosen-select Drop3Col" runat="server" AutoPostBack="True">
                                    <%-- <asp:ListItem Value="1" Text="Thông báo về quyền lựa chọn hoà giải và lựa chọn hoà giải viên"></asp:ListItem>--%>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td class="Col1">Số lần<span class="batbuoc">(*)</span></td>
                            <td colspan="3">
                                <asp:TextBox ID="txtSoLan" CssClass="user d-validator-required" runat="server"></asp:TextBox>
                            </td>

                        </tr>
                        <tr>
                            <td class="Col1">Đương sự<span class="batbuoc">(*)</span></td>
                            <td colspan="3">
                                <asp:CheckBoxList ID="chkDuongSu" runat="server" CssClass="httitle" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="chkDuongSu_SelectedIndexChanged">
                                </asp:CheckBoxList>
                            </td>
                        </tr>
                        <tr>
                            <td class="Col1">Ngày thông báo<span class="batbuoc">(*)</span></td>
                            <td class="Col2">
                                <asp:TextBox ID="txtNgayThongBao" runat="server" CssClass="user txtCalendar d-validator-required"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayThongBao"
                                    Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayThongBao"
                                    Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <td class="Col3">Số thông báo<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtSoThongBao" CssClass="user d-validator-required" runat="server" Width="242px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="Col1">Người ký<span class="batbuoc">(*)</span></td>
                            <td class="Col2">
                                <asp:DropDownList ID="ddlNguoiKy" AutoPostBack="false" CssClass="user chosen-select Drop1Col d-validator-required" runat="server">
                                </asp:DropDownList>
                        </tr>
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
                                    <asp:LinkButton ID="lbtDownload" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownload_Click"></asp:LinkButton>
                                </td>
                            </asp:Panel>
                        </tr>
                        <tr>
                            <td style="padding-top: 20px" colspan="1000">
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
                                <%--<asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>--%>
                            </div>

                            <asp:Panel runat="server" ID="pndata" Visible="false">
                                <%--<div class="phantrang">
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
                                </div>--%>
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="10px">
                                            <HeaderTemplate>
                                                Lần TB
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("SOLAN") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left" HeaderStyle-Width="30px">
                                            <HeaderTemplate>
                                                Số thông báo
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("SOTHONGBAO") %>
                                                <br />
                                                <%# String.Format("{0:dd/MM/yyyy}", Eval("NGAYTHONGBAO") ) %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="TENDUONGSU" HeaderText="Đương sự" HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGUOIKY" HeaderText="Người ký" HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGUOITAO" HeaderText="Người tạo" HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="30px">
                                            <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:ImageButton ID="lblDownload" ImageUrl="~/UI/img/ghim.png" runat="server" CausesValidation="false" CommandName="Download"
                                                    CommandArgument='<%#Eval("FILEID") %>' ToolTip='<%#Eval("TENFILE")%>' />
                                                <%--<asp:LinkButton ID="lblDownload" runat="server" Text='<%#Eval("TENFILE") %>'  CssClass="TenFile_css"></asp:LinkButton>--%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                &nbsp;&nbsp;
                                                <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                            
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                                <%--<div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:HiddenField ID="hdicha" runat="server" />
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
                                </div>--%>
                            </asp:Panel>
                        </td>
                    </tr>
                </table>

            </div>
        </div>
    </div>
    <script>
        //$(document).ready(function () {
        //    $(".d-file-upload div input").addClass("user");
        //});
    </script>

    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }

        }
        function Setfocus(controlid) {
            var ctrl = document.getElementById(controlid);
            ctrl.focus();
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
