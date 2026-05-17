<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="PhanCongThamPhan.aspx.cs" Inherits="WEB.GSTP.QLAN.HOAGIAI.PhanCongThamPhan" %>

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

        .d-not-vaild {
            border: solid 1px red !important;
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
                <h4 class="tleboxchung">
                    <asp:Label runat="server" ID="lbTitle" Text="Phân công Thẩm phán/Chỉ định hoà giải viên"></asp:Label>
                </h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">

                        <tr>
                            <td class="Col1">Vai trò<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:DropDownList ID="ddlVaitro" CssClass="user chosen-select Drop1Col" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlVaitro_SelectedIndexChanged">
                                </asp:DropDownList>
                            </td>
                        </tr>

                        <asp:Panel ID="pnlPhanCong" runat="server" Visible="false">
                            <asp:TextBox ID="txtHoaGiaThamPhanId" runat="server" Visible="false" />
                            <tr>
                                <td class="Col1">Thẩm phán<span class="batbuoc">(*)</span></td>
                                <td class="Col2">
                                    <asp:DropDownList ID="ddlThamphan" AutoPostBack="true" CssClass="user chosen-select Drop1Col" runat="server">
                                    </asp:DropDownList>
                            </tr>
                            <tr>
                                <td class="Col1">Ngày phân công<span class="batbuoc">(*)</span></td>
                                <td class="Col2">
                                    <asp:TextBox ID="txtNgayphancong" runat="server"
                                        CssClass="user d-validator-required txtCalendar" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="txtNgayphancong_CalendarExtender" runat="server" TargetControlID="txtNgayphancong" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayphancong" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator1" CssClass="d-validator-message" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayphancong" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                </td>
                                <asp:Panel ID="pnlNgayNhanPhanCong" runat="server" Visible="true">
                                    <td class="Col3">Ngày nhận phân công <span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNhanphancong" runat="server" CssClass="user txtCalendar d-validator-required" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNhanphancong" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNhanphancong" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        <cc1:MaskedEditValidator ID="MaskedEditValidator2" CssClass="d-validator-message" runat="server" ControlExtender="MaskedEditExtender2" ControlToValidate="txtNhanphancong" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>

                                    </td>
                                </asp:Panel>


                            </tr>
                            <tr>
                                <td>Người phân công<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlNguoiphancong" CssClass="user chosen-select Drop1Col" runat="server"></asp:DropDownList>
                                <td></td>
                                <td></td>
                            </tr>

                            <tr>
                                <td class="Col1">Ghi chú</td>
                                <td colspan="2">
                                    <asp:TextBox ID="txtGhiChuPC" CssClass="user" runat="server" Width="100%" MaxLength="500" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                </td>
                            </tr>

                        </asp:Panel>
                        <asp:Panel ID="pnlChiDinh" runat="server" Visible="false">
                            <tr>
                                <td class="Col1"></td>
                                <td>
                                    <asp:RadioButtonList ID="rdbIsLuaChonHGV" runat="server" AutoPostBack="true" OnSelectedIndexChanged="rdbIsLuaChonHGV_SelectedIndexChanged"
                                        CssClass="radio_cts" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="1" Selected="true">Lựa chọn HGV</asp:ListItem>
                                        <asp:ListItem Value="2">Chỉ định HGV</asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td class="Col1">Hoà giải viên<span class="batbuoc">(*)</span></td>
                                <td class="Col2">
                                    <asp:DropDownList ID="ddlHGV" AutoPostBack="true" CssClass="user chosen-select Drop1Col" runat="server">
                                        <%--<asp:ListItem Text="----Chọn-----" Value="0" />--%>
                                    </asp:DropDownList>
                                <td class="Col3">Toà án trực thuộc</td>
                                <td>
                                    <asp:DropDownList ID="ddlToaAnTrucThuoc" AutoPostBack="true" CssClass="user chosen-select Drop1Col" runat="server" >
                                        <asp:ListItem Text="----Chọn-----" Value="0" />
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <asp:Panel ID="pnHGVOption" runat="server" Visible="true">
                                <tr>
                                    <td>Ngày chỉ định</td>
                                    <td>
                                        <asp:TextBox ID="txtNgayChiDinh" runat="server"
                                            AutoPostBack="True" CssClass="user txtCalendar" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayChiDinh" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtNgayChiDinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayChiDinh" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                    </td>

                                </tr>
                                <tr>
                                    <td class="Col1">Lý do chỉ định</td>
                                    <td colspan="2">
                                        <asp:TextBox ID="txtGhiChu" CssClass="user" runat="server" Width="100%" MaxLength="500" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <tr>
                                <td class="Col1">Người phân công<span class="batbuoc">(*)</span></td>
                                <td class="Col2">
                                    <asp:DropDownList ID="ddlNguoiPhanCongHGV" CssClass="user chosen-select Drop1Col" runat="server"></asp:DropDownList>
                            </td>
                                <td class="Col3">Người ký<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNguoiKyCD" CssClass="user d-validator-required" runat="server" Width="242px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td class="Col1">Ghi chú</td>
                                <td colspan="2">
                                    <asp:TextBox ID="txtGhiChuLC" CssClass="user" runat="server" Width="100%" MaxLength="500" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                            </tr>
                        </asp:Panel>
                        <tr>
                            <td colspan="1000" style="padding-top: 20px">
                                <asp:Label runat="server" CssClass="d-thongbao" ID="lblThongBao" ForeColor="Red"></asp:Label>
                            </td>
                        </tr>

                    </table>
                </div>
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
                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                        </div>

                        <asp:Panel runat="server" ID="pndata" Visible="true">
                            <%-- <div class="phantrang">
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
                                    <asp:TemplateColumn HeaderStyle-Width="45px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            TT
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Container.DataSetIndex + 1 %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="220px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Vai trò
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Label ID="VAITRO" runat="server" Text='<%#Eval("VAITRO") %>'></asp:Label>
                                            <%-- <%#Eval("VAITRO") %>--%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Họ và tên
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("HOTEN") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <%--<asp:BoundColumn DataField="THAMPHAN_HOTEN" HeaderText="Tên thẩm phán" HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>--%>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Người phân công
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("NGUOIPHANCONG") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="NGAYPHANCONG" HeaderText="Ngày phân công" HeaderStyle-Width="130px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGAYNHANPHANCONG" HeaderText="Ngày nhận phân công" HeaderStyle-Width="130px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                    <%--<asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Hòa giải viên
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("HGV_HOTEN") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>--%>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Tòa án trực thuộc
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("TOAANTRUCTHUOC") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Thao tác
                                        </HeaderTemplate>
                                        <%--<ItemStyle Height="30px" />--%>
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
                            <%-- <div class="phantrang">
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
    <script>
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function validate() {
            let isPass = true;
            let countRun = 0;
            let total = $(".d-validator-required").length;
            $(".d-validator-required").each(function (index, element) {
                let value = $(element).val();
                if (value == null || value == "") {
                    let message = $(element).parent().find('.d-validator-message');
                    message.text("Không được để trống");
                    message.css("visibility", "inherit")
                    $(element).addClass("d-not-vaild");
                    isPass = false;
                }
                countRun++;
            });
            //$(".d-validator-required").each(function (index, element) {
            //    let value = $(element).val();
            //    if (value == null || value == "") {
            //        let message = $(element).parent().find('.d-validator-message');
            //        message.text("Không được để trống");
            //        message.css("visibility", "inherit")
            //        $(element).addClass("d-not-vaild");
            //        isPass = false;
            //    }
            //    countRun++;
            //});
            while (countRun < total)
                break;
            if (isPass == false)
                alert("Hãy điền đầy đủ thông tin");
            return isPass;
        }
        $(document).on('blur', '.d-validator-required', function (event) {
            $(this).parent().find('.d-validator-message').css("visibility", "hidden")
            $(this).removeClass("d-not-vaild");
        });
        //$(document).bind('DOMSubtreeModified', function () {
        //    console.log("Dương");
        //});
        function ThongBaoOnHide() {
            $(".d-thongbao").delay(3000).fadeOut(300);
        }
    </script>
</asp:Content>
