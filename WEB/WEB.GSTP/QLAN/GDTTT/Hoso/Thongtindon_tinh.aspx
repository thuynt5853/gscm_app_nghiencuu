<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Thongtindon_tinh.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.Hoso.Thongtindon_tinh" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <style type="text/css">
        .DonGDTCol1 {
            width: 115px;
        }

        .DonGDTCol2 {
            width: 260px;
        }

        .DonGDTCol3 {
            width: 105px;
        }

        .DonGDTCol4 {
            width: 260px;
        }

        .DonGDTCol5 {
            width: 55px;
        }

        .scroll_DS {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
            overflow-y: auto;
            overflow-x: auto;
            max-height: 300px;
        }

        .buttoncheck {
            font-weight: bold;
            color: #044271;
            text-decoration: none;
        }

        .button_empty {
            border: 1px solid red;
            border-radius: 4px;
            box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);
            color: #044271;
            background: white;
            float: left;
            font-size: 12px;
            font-weight: bold;
            line-height: 23px;
            padding: 0px 5px;
            margin-left: 3px;
            margin-bottom: 8px;
            text-decoration: none;
        }

        .button_empty_disable {
            border: 1px solid #9c9f9f;
            border-radius: 4px;
            box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);
            color: #9c9f9f;
            background: white;
            float: left;
            font-size: 12px;
            font-weight: bold;
            line-height: 23px;
            padding: 0px 5px;
            margin-left: 3px;
            margin-bottom: 8px;
            text-decoration: none;
        }
        /*//*/
        .clear_bottom {
            margin-bottom: 0px;
        }

        .tableva {
            /*border: solid 1px #dcdcdc;width: 100%;*/
            border-collapse: collapse;
            margin: 5px 0;
        }

            .tableva td {
                padding: 2px;
                padding-left: 2px;
                padding-left: 5px;
                vertical-align: middle;
            }
        /*-------------------------------------*/
        .table_list {
            border: solid 1px #dcdcdc;
            border-collapse: collapse;
            margin: 5px 0;
            width: 100%;
        }


            .table_list .header {
                background: #db212d;
                border: solid 1px #dcdcdc;
                padding: 2px;
                font-weight: bold;
                height: 30px;
                color: #ffffff;
            }

            .table_list header td {
                background: #db212d;
                border: solid 1px #dcdcdc;
                padding: 2px;
            }

            .table_list td {
                border: solid 1px #dcdcdc;
                padding: 5px;
                line-height: 17px;
                vertical-align: top;
            }

        .ajax__calendar_container {
            width: 220px;
        }

        .ajax__calendar_body {
            width: 100%;
            height: 140px;
        }

        .title_ds {
            float: left;
            width: 100%;
            font-weight: bold;
            margin: 5px 0px;
        }

        .listbc {
            float: left;
            width: 100%;
            margin: 3px 0px;
        }

        .listbc_item {
            float: left;
            width: 100%;
            border-bottom: dotted 1px #dcdcdc;
            margin-bottom: 5px;
            padding-bottom: 3px;
        }

            .listbc_item:last-child {
                border-bottom: none;
            }

        .col_tenbc {
            width: 150px;
        }

        .col_toidanh {
            width: 80px;
        }

        .loaibc {
            margin-left: 5px;
        }
    </style>
    <asp:HiddenField ID="hddID" runat="server" Value="0" />
    <asp:HiddenField ID="hddNext" runat="server" Value="0" />
    <asp:HiddenField ID="hddVuAnID" runat="server" Value="0" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <div runat="server" id="divCommandT" style="margin: 5px; text-align: center; width: 95%">
                    <div style="display: none;">
                        <asp:Button ID="cmd_loadbc" runat="server" CssClass="buttoninput" Text="Load bi cao" OnClick="cmd_loadbc_Click" />
                        <asp:Button ID="cmd_NguoiGui_check" runat="server" CssClass="buttoninput" Text="Check người gửi" OnClick="cmd_NguoiGui_check_Click" />
                    </div>
                    <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                    <asp:Button ID="cmdUpdateAndNew" runat="server" CssClass="buttoninput" Text="Lưu & Thêm mới" OnClick="cmdUpdateAndNew_Click" />
                    <asp:Button ID="cmdLamMoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLamMoi_Click" />
                    <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdQuaylai_Click" />
                </div>
                <%-- //-------------------------%>
                <div style="margin: 5px; text-align: center; width: 95%; color: red; font-size: 16px;">
                    <asp:Label ID="lstMsgT" Font-Size="17px" runat="server"></asp:Label>
                </div>
                <asp:Panel ID="pnBAQDGDT" runat="server">
                    <div class="boxchung">
                        <h4 class="tleboxchung">Thông tin BA/QĐ đề nghị GĐT, TT</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <tr>
                                    <td>Hình thức đơn
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlHinhthucdon" Width="250px" CssClass="chosen-select" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlHinhthucdon_SelectedIndexChanged">
                                            <asp:ListItem Value="5" Text="Văn bản hành chính,Tài liệu chung"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Đơn đề nghị GĐT,TT"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Đơn đề nghị GĐT,TT kèm theo CV chuyển đơn"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="Hồ sơ Kháng nghị GĐT,TT"></asp:ListItem>
                                            <asp:ListItem Value="6" Text="CV kiến nghị GĐT,TT"></asp:ListItem>
                                            <asp:ListItem Value="9" Text="CV kiến nghị GĐT,TT kèm Hồ sơ"></asp:ListItem>
                                            <asp:ListItem Value="7" Text="Thông báo phát hiện vi phạm pháp luật"></asp:ListItem>
                                            <asp:ListItem Value="8" Text="Đơn khiếu nại tư pháp"></asp:ListItem>
                                            <asp:ListItem Value="10" Text="Đơn khiếu nại tư pháp kèm CV chuyển đơn"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <asp:Panel ID="pn_LOAI_GDTTT" runat="server">
                                        <td>Thủ tục giải quyết</td>
                                        <td colspan="2">
                                            <asp:DropDownList ID="ddl_LOAI_GDTTT" Width="250px" CssClass="chosen-select" runat="server">
                                                <asp:ListItem Value="0" Text="--chọn--" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Giám đốc thẩm"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Tái thẩm"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Chưa xác định"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </asp:Panel>
                                    <asp:Panel ID="pn_Loai_KNTP" runat="server" Visible="false">
                                        <td>Loại đơn</td>
                                        <td colspan="2">
                                            <asp:RadioButtonList ID="rdbLoaiKNTC_cc" runat="server" Font-Bold="true" RepeatDirection="Horizontal">
                                                <asp:ListItem Value="1" Text="Đơn khiếu nại" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Đơn tố cáo"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </asp:Panel>
                                     <%--<td>
                                            <asp:CheckBox ID="cbkTPB3" runat="server" Text="Phân công cho thẩm phán bậc 3" /></td>--%> <%--NC 13/09/2025 thêm cb--%>
                                </tr>
                                <tr>
                                    <td>Loại QĐ/BA</td>
                                    <td>
                                        <asp:RadioButtonList ID="rdbBAQD" runat="server" Width="300px" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rdbBAQD_SelectedIndexChanged">
                                            <%-- <asp:ListItem Value="0" Text="Bản án" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Quyết định"></asp:ListItem>--%>

                                            <%--<asp:ListItem Value="1" Text="QĐ kháng nghị"></asp:ListItem>--%>
                                        </asp:RadioButtonList>
                                        <asp:TextBox ID="txtMaDon" Visible="false" runat="server" CssClass="user" Width="242px" MaxLength="50" Enabled="false"></asp:TextBox>
                                    </td>
                                    <td colspan="2">
                                        <asp:CheckBox ID="chkKN_TBTLD" runat="server" Text="Thông báo trả lời đơn" AutoPostBack="True" OnCheckedChanged="chkKN_TBTLD_CheckedChanged" Visible="false" />
                                        <asp:CheckBox ID="chkIsNotGDT" runat="server" Text="Không có nội dung GDT,TT" AutoPostBack="True" OnCheckedChanged="chkIsNotGDT_CheckedChanged" Visible="false" />
                                    </td>
                                </tr>
                                <asp:Panel ID="pnSoKhangNghi" runat="server" Visible="false">
                                    <tr>
                                        <td class="DonGDTCol1">Số quyết định <span runat="server" id="spSOKN" class="batbuoc">*</span></td>
                                        <td class="DonGDTCol2">
                                            <asp:TextBox ID="txtSoQDKN" runat="server" CssClass="user" Width="242px" MaxLength="50"></asp:TextBox>
                                        </td>
                                        <td class="DonGDTCol3">Ngày quyết định<span runat="server" id="spNGKN" class="batbuoc">*</span></td>
                                        <td>
                                            <asp:TextBox ID="txtNgayKhangNghi" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayKhangNghi" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayKhangNghi" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Người kháng nghị
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlNguoiKhangNghi" CssClass="chosen-select" runat="server" Width="250px">
                                            </asp:DropDownList>
                                        </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                </asp:Panel>
                                <asp:Panel ID="pnSoBA" runat="server">
                                    <tr>
                                        <td>
                                            <asp:Label ID="lbl_so_ba_qd" runat="server"></asp:Label><span runat="server" id="spSOBA" class="batbuoc">*</span></td>
                                        <td>
                                            <asp:TextBox ID="txtSoQDBA" runat="server" CssClass="user" Width="242px" MaxLength="50"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="lbl_ngay_ba_qd"></asp:Label><span runat="server" id="spNGBA" class="batbuoc">*</span></td>
                                        <td>
                                            <asp:TextBox ID="txtNgayBA" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayBA" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayBA" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>

                                    </tr>
                                    <tr>
                                        <td class="DonGDTCol1">Tòa xét xử<span runat="server" id="spTOAXX" class="batbuoc">*</span></td>
                                        <td class="DonGDTCol2">
                                            <asp:DropDownList ID="ddlToaXetXu" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlToaXetXu_SelectedIndexChanged"></asp:DropDownList>
                                        </td>
                                        <td class="DonGDTCol3">Cấp xét xử</td>
                                        <td>
                                            <asp:DropDownList ID="ddlCapXetXu" CssClass="chosen-select" runat="server" Width="250px"
                                                AutoPostBack="true" OnSelectedIndexChanged="ddlCapXetXu_SelectedIndexChanged">
                                            </asp:DropDownList></td>
                                    </tr>
                                    <tr runat="server" id="trTenToaXX" visible="false">
                                        <td>Tên tòa xét xử</td>
                                        <td colspan="3">
                                            <asp:Label ID="lblTentoaXX" ForeColor="Red" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                </asp:Panel>
                                <!---------------An PT----------------------------->
                                <asp:Panel ID="pnPhucTham" runat="server">
                                    <tr>
                                        <td colspan="4" style="border-bottom: 1.5px dotted #808080;"></td>
                                    </tr>
                                    <tr>
                                        <td style="width: 120px;">Số BA Phúc thẩm</td>
                                        <td style="width: 255px;">
                                            <asp:TextBox ID="txtSoBA_PT" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>
                                        <td style="width: 95px;">Ngày BA Phúc thẩm</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayBA_PT" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayBA_PT" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayBA_PT"
                                                Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Tòa án xét xử PT</td>
                                        <td>
                                            <asp:DropDownList ID="dropToaAnPT" CssClass="chosen-select"
                                                AutoPostBack="true" OnSelectedIndexChanged="dropToaAnPT_SelectedIndexChanged"
                                                runat="server" Width="250px">
                                            </asp:DropDownList>
                                        </td>
                                        <td colspan="2"></td>
                                    </tr>
                                </asp:Panel>
                                <!-----------An ST--------------------------------->
                                <asp:Panel ID="pnAnST" runat="server">
                                    <tr>
                                        <td colspan="4" style="border-bottom: 1.5px dotted #808080;"></td>
                                    </tr>
                                    <tr>
                                        <td>Số BA Sơ thẩm</td>
                                        <td>
                                            <asp:TextBox ID="txtSoBA_ST" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>
                                        <td>Ngày BA Sơ thẩm</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayBA_ST" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txtNgayBA_ST" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txtNgayBA_ST"
                                                Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Tòa án xét xử sơ thẩm</td>
                                        <td>
                                            <asp:DropDownList ID="dropToaAnST" CssClass="chosen-select"
                                                runat="server" Width="250px">
                                            </asp:DropDownList>
                                        </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" style="border-bottom: 1.5px dotted #808080;"></td>
                                    </tr>
                                </asp:Panel>
                                <!-----------End An ST--------------------------------->
                                <tr runat="server" id="trThongbaoTLD" visible="false">
                                    <td>
                                        <asp:DropDownList ID="ddlSoTBTLD" CssClass="chosen-select" runat="server" Width="115px" AutoPostBack="True" OnSelectedIndexChanged="ddlSoTBTLD_SelectedIndexChanged"></asp:DropDownList>
                                    </td>
                                    <td colspan="3">
                                        <asp:DataGrid ID="dgTBTLD" runat="server" AutoGenerateColumns="False" CellPadding="4" Width="630px"
                                            PageSize="10" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                            ItemStyle-CssClass="chan" OnItemCommand="dgTBTLD_ItemCommand" OnItemDataBound="dgTBTLD_ItemDataBound">
                                            <Columns>
                                                <asp:BoundColumn DataField="ID" HeaderStyle-Width="20px" HeaderText="ID" Visible="false" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="110px" ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Số thông báo</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtSo" runat="server" Text='<%# Eval("SO")%>' CssClass="user" Width="110px" MaxLength="250"></asp:TextBox>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="80px">
                                                    <HeaderTemplate>Ngày</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtNgay" runat="server" Text='<%# GetDate(Eval("NGAY"))%>' CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="txtNgay_CalendarExtender" runat="server" TargetControlID="txtNgay" Format="dd/MM/yyyy" />
                                                        <cc1:MaskedEditExtender ID="txtNgay_MaskedEditExtender3" runat="server" TargetControlID="txtNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" Century="2000" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Tòa án</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:HiddenField ID="hddToaID" runat="server" Value='<%# Eval("DONVITB")%>' />
                                                        <asp:DropDownList ID="ddlToaAn" CssClass="chosen-select" runat="server" Width="320px"></asp:DropDownList>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="40px" Visible="false" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Xóa</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <div class="tooltip">
                                                            <asp:ImageButton ID="cmdXoa" runat="server" ToolTip="Xóa" CssClass="grid_button"
                                                                CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                ImageUrl="~/UI/img/delete.png" Width="17px"
                                                                OnClientClick="return confirm('Bạn thực sự muốn xóa thông báo này? ');" />
                                                            <span class="tooltiptext  tooltip-bottom">Xóa</span>
                                                        </div>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                </asp:TemplateColumn>
                                            </Columns>
                                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        </asp:DataGrid>
                                    </td>
                                </tr>
                                <asp:Panel ID="pnKiemtraTrung" runat="server" Visible="false">
                                    <tr>
                                        <td>Trùng với đơn</td>
                                        <td colspan="3">
                                            <asp:HiddenField ID="hddDontrungID" runat="server" Value="0" />
                                            <asp:TextBox ID="txtTenDonTrung" placeholder="Nhập thêm tên người gửi để kiểm tra trùng" CssClass="user" Width="538px" runat="server"></asp:TextBox>
                                            <asp:Button ID="cmdCheckTrungDon" runat="server" Text="Kiểm tra" OnClick="cmdCheckTrungDon_Click" CssClass="buttoninput" Height="25px" />
                                            <asp:Button ID="cmdHuyTrungDon" runat="server" Text="Hủy trùng" Visible="false" OnClick="cmdHuyTrungDon_Click" CssClass="buttoninput" Height="25px" />
                                        </td>
                                    </tr>
                                    <tr runat="server" id="trDSTrung" visible="false">
                                        <td colspan="4">
                                            <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                                            <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                                            <div class="phantrang">
                                                <div class="sobanghi">
                                                    <asp:Button ID="cmdThugon" runat="server" Text="Thu gọn" OnClick="cmdThugon_Click" CssClass="buttoninput" Height="25px" />

                                                    <asp:Literal ID="lstSobanghiT" Visible="false" runat="server"></asp:Literal>
                                                </div>
                                                <div class="sotrang">
                                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active" Visible="true"
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
                                                </div>
                                            </div>
                                            <asp:DataGrid ID="dgListTrung" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                PageSize="5" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                                ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgListTrung_ItemCommand">
                                                <Columns>
                                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="90px">
                                                        <HeaderTemplate>
                                                            Đơn trùng
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:Button ID="cmdChitiet" runat="server" Text="Chọn đơn" CssClass="buttonchitiet" CausesValidation="false" CommandName="Select" CommandArgument='<%#Eval("ID") +";"+Eval("VUAN_ID")+";"+Eval("LOAIAN")%>' />
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                    </asp:TemplateColumn>
                                                    <asp:BoundColumn DataField="NGAYNHANDON" HeaderText="Ngày nhận" HeaderStyle-Width="65px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                                    <asp:BoundColumn DataField="NGUOIGUI_HOTEN" HeaderText="Người gửi đơn" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="125px"></asp:BoundColumn>
                                                    <asp:BoundColumn DataField="Diachigui" HeaderText="Địa chỉ" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top">
                                                        <HeaderTemplate>Thông tin BA/QĐ</HeaderTemplate>
                                                        <ItemTemplate>
                                                            Số <%#Eval("SOBAQD") %>;&nbsp;Ngày: <%# GetDate(Eval("NGAYBAQD")) %>;&nbsp;<%#Eval("TOAXETXU") %>
                                                            <%#Eval("LOAI_AN_TEN") %>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderStyle-Width="105px" HeaderStyle-HorizontalAlign="Center">
                                                        <HeaderTemplate>Người nhập</HeaderTemplate>
                                                        <ItemTemplate>
                                                            <b><%#Eval("Nguoitao") %></b><br />
                                                            <%# Convert.ToDateTime(Eval("Ngaytao")).ToString("dd/MM/yyyy HH:mm") %>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                                    </asp:TemplateColumn>
                                                </Columns>
                                                <HeaderStyle CssClass="header"></HeaderStyle>
                                                <ItemStyle CssClass="chan"></ItemStyle>
                                                <PagerStyle Visible="false"></PagerStyle>
                                            </asp:DataGrid>

                                            <div class="phantrang" style="display: none;">
                                                <div class="sobanghi" style="display: none;">
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
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </asp:Panel>
                            </table>
                        </div>
                    </div>
                </asp:Panel>
                <asp:Panel ID="pnKNTCDoituong" runat="server" Visible="false">
                    <div class="boxchung">
                        <h4 class="tleboxchung">Đối tượng bị khiếu nại, tố cáo</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <tr>
                                    <td>Hình thức đơn
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlHinhthucdon_kntc" Width="250px" CssClass="chosen-select" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlHinhthucdon_kntc_SelectedIndexChanged">
                                            <asp:ListItem Value="5" Text="Văn bản hành chính,Tài liệu chung"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Đơn đề nghị GĐT,TT"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Đơn đề nghị GĐT,TT kèm theo CV chuyển đơn"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="Hồ sơ Kháng nghị GĐT,TT"></asp:ListItem>
                                            <asp:ListItem Value="6" Text="CV kiến nghị GĐT,TT"></asp:ListItem>
                                            <asp:ListItem Value="9" Text="CV kiến nghị GĐT,TT kèm Hồ sơ"></asp:ListItem>
                                            <asp:ListItem Value="7" Text="Thông báo phát hiện vi phạm pháp luật"></asp:ListItem>
                                            <asp:ListItem Value="8" Text="Đơn khiếu nại tư pháp"></asp:ListItem>
                                            <asp:ListItem Value="10" Text="Đơn khiếu nại tư pháp kèm CV chuyển đơn"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="DonGDTCol1">Loại đơn</td>
                                    <td class="DonGDTCol2">
                                        <asp:RadioButtonList ID="rdbLoaiKNTC" runat="server" Font-Bold="true" RepeatDirection="Horizontal">
                                            <asp:ListItem Value="1" Text="Đơn khiếu nại" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Đơn tố cáo"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                    <td colspan="2"></td>
                                </tr>
                                <tr>
                                    <td>Đối tượng bị KN,TC<span runat="server" class="batbuoc">*</span></td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtDoituongbiKN" CssClass="user" runat="server" Width="625px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Phân loại KN,TC
                                    </td>
                                    <td colspan="3">
                                        <asp:CheckBoxList ID="chkPhanloai" runat="server" RepeatColumns="3" RepeatDirection="Horizontal"></asp:CheckBoxList>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </asp:Panel>
                <asp:Panel ID="PN_HOSO_KN" runat="server" Visible="false">
                    <div class="boxchung">
                        <h4 class="tleboxchung">Thông tin Quyết định Kháng nghị</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <tr>
                                    <td>
                                        <div style="float: left; width: 810px; margin-top: 10px; margin-left: 5px;">
                                            <div style="width: 810px; float: left; margin-top: 7px;">
                                                <div style="float: left; width: 120px; text-align: right;">Số QĐKN<span style="color: #ff0000; padding-left: 5px;">(*)</span></div>
                                                <div style="float: left; width: 200px; margin-left: 7px;">
                                                    <asp:TextBox ID="txtSOKN" runat="server"
                                                        CssClass="user" Width="200px" Text=""></asp:TextBox>
                                                </div>
                                                <div style="float: left; width: 190px; text-align: right;">Ngày QĐKN<span style="color: #ff0000; padding-left: 5px;">(*)</span></div>
                                                <div style="float: left; width: 200px; margin-left: 7px;">
                                                    <asp:TextBox ID="txt_NGAYQDKN" CssClass="user" runat="server" Width="200px"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender10" runat="server" TargetControlID="txt_NGAYQDKN" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender10" runat="server" TargetControlID="txt_NGAYQDKN" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </div>
                                            </div>
                                            <div style="width: 810px; float: left; margin-top: 7px;">
                                                <div style="float: left; width: 120px; text-align: right;">Người Kháng nghị<span style="color: #ff0000; padding-left: 5px;">(*)</span></div>
                                                <div style="float: left; width: 209px; margin-left: 7px;">
                                                    <asp:DropDownList ID="drop_DONVICHUYEN_HSKN" CssClass="chosen-select"
                                                        runat="server" Width="209px">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div style="width: 810px; float: left; margin-top: 7px;">
                                                <div style="float: left; width: 120px; text-align: right;">Ngày nhận<span style="color: #ff0000; padding-left: 5px;">(*)</span></div>
                                                <div style="float: left; width: 200px; margin-left: 7px;">
                                                    <asp:TextBox ID="txtNgaynhandon_kn" CssClass="user" runat="server" Width="200px"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender11" runat="server" TargetControlID="txtNgaynhandon_kn" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender11" runat="server" TargetControlID="txtNgaynhandon_kn" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </div>
                                                <div style="float: left; width: 190px; text-align: right;">Ý kiến chỉ đạo ?</div>
                                                <div style="float: left; width: 200px; margin-left: 7px;">
                                                    <asp:DropDownList ID="ddlCAChidao_kn" CssClass="chosen-select" runat="server" Width="210px" AutoPostBack="true" OnSelectedIndexChanged="ddlCAChidao_kn_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div runat="server" id="trChidao_kn" style="width: 810px; float: left; margin-top: 5px;">
                                                <div style="float: left; width: 120px; text-align: right;">
                                                    Nội dung chỉ đạo
                                                    <br />
                                                    <asp:LinkButton ID="lbtGYChidao_kn" runat="server" Text="[ Copy ]" ForeColor="Blue" OnClick="lbtGYChidao_kn_Click"></asp:LinkButton>

                                                </div>
                                                <div style="float: left; width: 597px; margin-left: 7px;">
                                                    <asp:TextBox ID="txtCA_Noidung_kn" CssClass="user" TextMode="MultiLine" Rows="4" runat="server" Width="597px"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div style="width: 810px; float: left; margin-top: 7px;">
                                                <div style="float: left; width: 120px; text-align: right;">Tổng số bút lục</div>
                                                <div style="float: left; width: 200px; margin-left: 7px;">
                                                    <asp:TextBox ID="txtTongButLucKN" runat="server"
                                                        CssClass="user" Width="200px" Text=""></asp:TextBox>
                                                </div>
                                                <div style="float: left; width: 190px; text-align: right;">Số thứ tự nhận HS</div>
                                                <div style="float: left; width: 200px; margin-left: 7px;">
                                                    <asp:TextBox ID="txtSoTTNhanHSKN" runat="server"
                                                        CssClass="user" Width="200px" Text=""></asp:TextBox>
                                                </div>
                                            </div>
                                            <div style="width: 810px; float: left; margin-top: 7px;">
                                                <div style="float: left; width: 120px; text-align: right;">Từ số</div>
                                                <div style="float: left; width: 200px; margin-left: 7px;">
                                                    <asp:TextBox ID="txtTuSoKN" runat="server"
                                                        CssClass="user" Width="200px" Text=""></asp:TextBox>
                                                </div>
                                                <div style="float: left; width: 190px; text-align: right;">Đến số</div>
                                                <div style="float: left; width: 200px; margin-left: 7px;">
                                                    <asp:TextBox ID="txtDenSoKN" runat="server"
                                                        CssClass="user" Width="200px" Text=""></asp:TextBox>
                                                </div>
                                            </div>
                                            <div style="width: 810px; float: left; margin-top: 5px;">
                                                <div style="float: left; width: 120px; text-align: right;">Nội dung kháng nghị</div>
                                                <div style="float: left; width: 597px; margin-left: 7px;">
                                                    <asp:TextBox ID="txtNoiDungKN" runat="server"
                                                        CssClass="user" Width="597px" Text="" Rows="2" TextMode="MultiLine"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div style="width: 810px; float: left; margin-top: 5px;">
                                                <div style="float: left; width: 120px; text-align: right;">Ghi chú</div>
                                                <div style="float: left; width: 597px; margin-left: 7px;">
                                                    <asp:TextBox ID="txt_GHICHU_HS" runat="server"
                                                        CssClass="user" Width="597px" Text="" Rows="2" TextMode="MultiLine"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </asp:Panel>
                <asp:Panel ID="PN_VBHC_TL" runat="server" Visible="true">
                    <div class="boxchung">
                        <h4 class="tleboxchung">Thông tin văn bản</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <tr>
                                    <td class="DonGDTCol1">Số VB<span class="batbuoc">*</span></td>
                                    <td class="DonGDTCol2">
                                        <asp:TextBox ID="txtSohieudon_VB" runat="server" CssClass="user" Width="242px" MaxLength="50"></asp:TextBox>
                                    </td>
                                    <td>
                                        <div style="float: left; width: 120px; text-align: right; margin-top: 5px;">Ngày trên văn bản<span class="batbuoc">*</span></div>
                                        <div style="float: left; margin-left: 7px;">
                                            <asp:TextBox ID="txtVB_Ngay" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender14" runat="server" TargetControlID="txtVB_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender14" runat="server" TargetControlID="txtVB_Ngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Ngày nhận VB</td>
                                    <td>
                                        <asp:TextBox ID="txtNgaynhandon_VB" runat="server" CssClass="user"
                                            Width="242px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender12" runat="server" TargetControlID="txtNgaynhandon_VB"
                                            Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender12" runat="server" TargetControlID="txtNgaynhandon_VB"
                                            Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>Người gửi là</td>
                                    <td>
                                        <asp:DropDownList ID="ddlDungdonla_VB" Width="250px" CssClass="chosen-select" runat="server">
                                            <asp:ListItem Value="1" Text="Cá nhân" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Các ông, bà"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Cơ quan, tổ chức"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" ID="Label1"> Người gửi<span class="batbuoc">*</span></asp:Label></td>
                                    <td>
                                        <asp:TextBox ID="txtNguoigui_VB" runat="server" CssClass="user" Width="242px" MaxLength="250"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" ID="lbl_diachi_gui_vb">Địa chỉ gửi</asp:Label></td>
                                    <td>
                                        <asp:DropDownList ID="ddl_DIACHI_GUI_BT_ID" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                    </td>
                                    <td>
                                        <div style="float: left; width: 120px; text-align: right; margin-top: 5px;">Chi tiết</div>
                                        <div style="float: left; margin-left: 7px;">
                                            <asp:TextBox ID="txtDiachi_VB" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblTitleNoidung_VB" runat="server" Text="Nội dung VB"></asp:Label>
                                    </td>
                                    <td colspan="4">
                                        <asp:TextBox ID="txtNoidung_VB" CssClass="user" runat="server" TextMode="MultiLine" Width="88%" Rows="3"></asp:TextBox>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Ghi chú   
                                    </td>
                                    <td colspan="4">
                                        <asp:TextBox ID="txtGhichu_VB" autocomplete="off" CssClass="user" runat="server" TextMode="MultiLine" Width="88%" Rows="2" MaxLength="2000"></asp:TextBox>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr runat="server" id="trKQGQ_VB">
                                    <td>Kết quả giải quyết ?</td>
                                    <td>
                                        <asp:DropDownList ID="ddlTraloi_VB" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="true" OnSelectedIndexChanged="ddlTraloi_VB_SelectedIndexChanged">
                                            <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Không"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Chưa xác định" Selected="True"></asp:ListItem>
                                        </asp:DropDownList></td>
                                    <td colspan="4"></td>
                                </tr>
                                <asp:Panel ID="pnCV_traloi_VB" runat="server" Visible="false">
                                    <tr>
                                        <td>Nội dung kết quả giải quyết</td>
                                        <td colspan="4">
                                            <asp:TextBox ID="txtCV_Traloi_Noidung_VB" CssClass="user" TextMode="MultiLine" Rows="2" runat="server" Width="88%"></asp:TextBox>
                                        </td>
                                        <td></td>
                                    </tr>
                                </asp:Panel>
                                <tr>
                                    <td>Ý kiến chỉ đạo ?</td>
                                    <td>
                                        <asp:DropDownList ID="ddlCAChidao_VB" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="true" OnSelectedIndexChanged="ddlCAChidao_VB_SelectedIndexChanged">
                                        </asp:DropDownList></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr id="trChidao_VB" runat="server" visible="false">
                                    <td>Nội dung chỉ đạo
                                    </td>
                                    <td colspan="4">
                                        <asp:TextBox ID="txtCA_Noidung_VB" CssClass="user" TextMode="MultiLine" Rows="4" runat="server" Width="88%"></asp:TextBox>
                                    </td>
                                    <td></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </asp:Panel>
                <asp:Panel ID="PN_DON_CV" runat="server" Visible="true">
                    <div class="boxchung">
                        <h4 class="tleboxchung">Thông tin đơn/công văn</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <tr>
                                    <td class="DonGDTCol1">Số hiệu đơn</td>
                                    <td class="DonGDTCol2">
                                        <asp:TextBox ID="txtSohieudon" runat="server" CssClass="user" Width="242px" MaxLength="50"></asp:TextBox>
                                    </td>
                                    <td class="DonGDTCol3"></td>
                                    <td class="DonGDTCol4"></td>
                                    <td class="DonGDTCol5"></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Ngày nhận<span class="batbuoc">*</span></td>
                                    <td>
                                        <%--  <asp:TextBox ID="txtNgaynhandon" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaynhandon" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaynhandon" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />--%>
                                        <asp:TextBox ID="txtNgaynhandon" runat="server" CssClass="user"
                                            Width="242px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgaynhandon"
                                            Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgaynhandon"
                                            Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                    </td>
                                    <td>
                                        <asp:Label ID="lblTitleNgaytrendon" runat="server" Text="Ngày ghi trên đơn *"></asp:Label></td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtNgayghidon" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayghidon" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayghidon" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>

                                </tr>
                                <asp:Panel ID="pnTTDon" runat="server">
                                    <tr>
                                        <td>Đứng đơn là</td>
                                        <td>
                                            <asp:DropDownList ID="ddlDungdonla" Width="250px" CssClass="chosen-select" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlDungdonla_SelectedIndexChanged">
                                                <asp:ListItem Value="1" Text="Cá nhân" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Các ông, bà"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Cơ quan, tổ chức"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblTucach" runat="server" Text="Tư cách tố tụng"></asp:Label>
                                        </td>
                                        <td colspan="3">
                                            <asp:DropDownList ID="ddlTucachTT" CssClass="chosen-select" runat="server" Width="250px">
                                                <%-- <asp:ListItem Value="1" Text="Bị can/Đương sự" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Người tham gia tố tụng"></asp:ListItem>--%>


                                                <asp:ListItem Value="5" Text="Nguyên đơn/Người khởi kiện"></asp:ListItem>
                                                <asp:ListItem Value="6" Text="Bị đơn/Người bị kiện"></asp:ListItem>
                                                <asp:ListItem Value="7" Text="Bị cáo"></asp:ListItem>
                                                <asp:ListItem Value="8" Text="Bị hại"></asp:ListItem>
                                                <asp:ListItem Value="9" Text="Người có quyền lợi nghĩa vụ liên quan"></asp:ListItem>


                                                <asp:ListItem Value="3" Text="Người không liên quan đến vụ án"></asp:ListItem>
                                                <asp:ListItem Value="4" Text="Khác"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="lbl_nguoi_gui"> Người gửi</asp:Label><span class="batbuoc">*</span></td>
                                        <td>
                                            <asp:TextBox ID="txtNguoigui" runat="server" CssClass="user" Width="242px" MaxLength="250"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="lbl_Gioitinh"> Giới tính</asp:Label>
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlGioitinh" CssClass="chosen-select" runat="server" Width="250px">
                                                <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                                <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td></td>
                                        <td></td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="lbl_diachi_gui">Địa chỉ gửi</asp:Label><span class="batbuoc">*</span></td>
                                        <td>
                                            <asp:HiddenField ID="hddNGDCID" runat="server" Value="0" />
                                            <a alt="Nhập tên huyện để chọn" class="tooltipleft">
                                                <asp:TextBox ID="txtNGHuyen" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                            </a>
                                        </td>
                                        <td>Chi tiết
                                        </td>
                                        <td colspan="2">
                                            <asp:TextBox ID="txtDiachi" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Số điện thoại</td>
                                        <td>
                                            <asp:TextBox ID="txtSoDienThoai" runat="server" CssClass="user" Width="242px" MaxLength="50"></asp:TextBox></td>

                                        <td>Số CMND</td>
                                        <td>
                                            <asp:TextBox ID="txtSoCMND" runat="server" CssClass="user" Width="242px" MaxLength="15"></asp:TextBox></td>
                                        <td></td>
                                        <td></td>
                                    </tr>

                                    <tr>
                                        <td></td>
                                        <td>
                                            <asp:CheckBox ID="chkGDTIsKNTC" runat="server" Text="Có nội dung tố cáo" /></td>

                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <%--     <tr>
                                        <td></td>
                                        <td>
                                            <asp:CheckBox ID="chkGDTIsKNTC" runat="server" Text="Có nội dung tố cáo" /></td>

                                        <td>Số CMND</td>
                                        <td>
                                            <asp:TextBox ID="txtSoCMND" runat="server" CssClass="user" Width="242px" MaxLength="50"></asp:TextBox></td>
                                        <td></td>
                                        <td></td>
                                    </tr>--%>
                                </asp:Panel>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblTitleNoidung" runat="server" Text="Nội dung đơn"></asp:Label>
                                        <br />
                                        <asp:LinkButton ID="lbtGYNoidung" runat="server" Text="[ Copy ]" ForeColor="Blue" OnClick="lbtGYNoidung_Click"></asp:LinkButton>
                                    </td>
                                    <td colspan="4">
                                        <asp:TextBox ID="txtNoidung" CssClass="user" runat="server" TextMode="MultiLine" Width="88%" Rows="3"></asp:TextBox>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Ghi chú
                                     <br />
                                        <asp:LinkButton ID="lbtGYGhichu" runat="server" Text="[ Copy ]" ForeColor="Blue" OnClick="lbtGYGhichu_Click"></asp:LinkButton>
                                    </td>
                                    <td colspan="4">
                                        <asp:TextBox ID="txtGhichu" autocomplete="off" CssClass="user" runat="server" TextMode="MultiLine" Width="88%" Rows="2" MaxLength="2000"></asp:TextBox>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr runat="server" id="trKQGQ">

                                    <td>Kết quả giải quyết ?</td>
                                    <td>
                                        <asp:DropDownList ID="ddlTraloi" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="true" OnSelectedIndexChanged="ddlTraloi_SelectedIndexChanged">
                                            <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Không"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Chưa xác định" Selected="True"></asp:ListItem>
                                        </asp:DropDownList></td>
                                    <td colspan="4"></td>
                                </tr>
                                <asp:Panel ID="pnCV_traloi" runat="server" Visible="false">
                                    <tr>
                                        <td>Nội dung kết quả giải quyết</td>
                                        <td colspan="4">
                                            <asp:TextBox ID="txtCV_Traloi_Noidung" CssClass="user" TextMode="MultiLine" Rows="2" runat="server" Width="88%"></asp:TextBox>
                                        </td>
                                        <td></td>
                                    </tr>
                                </asp:Panel>
                                <tr>
                                    <td>Ý kiến chỉ đạo ?</td>
                                    <td>
                                        <asp:DropDownList ID="ddlCAChidao" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="true" OnSelectedIndexChanged="ddlCAChidao_SelectedIndexChanged">
                                        </asp:DropDownList></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr id="trChidao" runat="server" visible="false">
                                    <td>Nội dung chỉ đạo
                                    <br />
                                        <asp:LinkButton ID="lbtGYChidao" runat="server" Text="[ Copy ]" ForeColor="Blue" OnClick="lbtGYChidao_Click"></asp:LinkButton>
                                    </td>
                                    <td colspan="4">
                                        <asp:TextBox ID="txtCA_Noidung" CssClass="user" TextMode="MultiLine" Rows="4" runat="server" Width="88%"></asp:TextBox>
                                    </td>
                                    <td></td>
                                </tr>
                                <asp:Panel ID="pnCongvan" runat="server" Visible="false">
                                    <tr runat="server" id="trTitleCongvan">
                                        <td colspan="6">
                                            <b>Thông tin công văn</b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Loại công văn</td>
                                        <td>
                                            <asp:DropDownList ID="ddlLoaiCongVan" Width="250px" CssClass="chosen-select" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlLoaiCongVan_SelectedIndexChanged"></asp:DropDownList>
                                        </td>
                                        <td colspan="4">
                                            <asp:CheckBox ID="chkIsTrongNganh" Checked="true" runat="server" AutoPostBack="true" Text="Đơn vị gửi trong ngành" OnCheckedChanged="chkIsTrongNganh_CheckedChanged" />
                                            &nbsp;&nbsp;<asp:CheckBox ID="chkTraigiam" Visible="false" runat="server" Text="Đơn vị là trại giam ?" AutoPostBack="true" OnCheckedChanged="chkTraigiam_CheckedChanged" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lstNguoiguiTitle" runat="server" Text="Người gửi/Đơn vị gửi"></asp:Label>
                                            <span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:Panel ID="pnDonViGuiNgoaiNganh" Visible="false" runat="server">
                                                <asp:TextBox ID="txtCV_DonViGuiNgoaiNganh" runat="server" CssClass="user" Width="242px" MaxLength="250"></asp:TextBox>
                                            </asp:Panel>
                                            <asp:Panel ID="pnDonViGuiTrongNganh" Visible="true" runat="server">
                                                <asp:DropDownList ID="ddlCV_Donvi" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>

                                            </asp:Panel>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblTraigiamhientai" runat="server" Visible="false" Text="Trại giam hiện tại (nếu thay đổi)"></asp:Label>
                                        </td>
                                        <td colspan="6">
                                            <asp:TextBox ID="txtTraigiamhientai" CssClass="user" Visible="false" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                        </td>

                                    </tr>
                                    <tr>
                                        <td>Địa chỉ gửi</td>
                                        <td>
                                            <asp:HiddenField ID="hddCVDCID" runat="server" Value="0" />
                                            <a alt="Nhập tên huyện để chọn" class="tooltipleft">
                                                <asp:TextBox ID="txtCVDC" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                            </a>
                                        </td>
                                        <td>Chi tiết
                                        </td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtCVDiachi" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Số công văn</td>
                                        <td>
                                            <asp:TextBox ID="txtCV_So" runat="server" CssClass="user" Width="242px" MaxLength="250"></asp:TextBox></td>
                                        <td>Ngày công văn</td>
                                        <td>
                                            <asp:TextBox ID="txtCV_Ngay" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtCV_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtCV_Ngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td>Người ký</td>
                                        <td>
                                            <asp:TextBox ID="txtCV_Nguoiky" runat="server" CssClass="user" Width="242px" MaxLength="250"></asp:TextBox>
                                        </td>
                                        <td>Chức vụ</td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtCV_Chucvu" runat="server" CssClass="user" Width="242px" MaxLength="250"></asp:TextBox>
                                        </td>
                                    </tr>

                                    <asp:Panel ID="pnCongVanNhacLai" runat="server" Visible="false">
                                        <tr>
                                            <td>Nhắc lại công văn</td>
                                            <td colspan="4">
                                                <a alt="Nhập số công văn để chọn(nếu có) hoặc nhập thông tin công văn" class="tooltipright">
                                                    <asp:TextBox ID="txtCongVan" CssClass="user" Width="88%" runat="server"></asp:TextBox>
                                                </a>
                                                <asp:HiddenField ID="hddNhaclaiCVID" runat="server" Value="0" />
                                            </td>
                                            <td></td>
                                        </tr>
                                    </asp:Panel>
                                    <tr>
                                        <td>Yêu cầu thông báo giải quyết</td>
                                        <td colspan="5">
                                            <asp:DropDownList ID="ddlYeucauthongbao" CssClass="chosen-select" runat="server" Width="250px">
                                                <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                </asp:Panel>
                                <tr runat="server" id="trDongkhieunai">
                                    <td>
                                        <b>Đồng khiếu nại</b>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlSonguoiKN" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlSonguoiKN_SelectedIndexChanged"></asp:DropDownList>
                                    </td>
                                    <td colspan="4">
                                        <asp:CheckBox ID="chkIsCongVan" runat="server" Text="Đơn có công văn ?" AutoPostBack="True" OnCheckedChanged="chkIsCongVan_CheckedChanged" />
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td colspan="5">
                                        <asp:DataGrid ID="dgNguoiKN" runat="server" AutoGenerateColumns="False" CellPadding="4" Width="635px"
                                            PageSize="10" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                            ItemStyle-CssClass="chan">
                                            <Columns>
                                                <asp:BoundColumn DataField="ID" HeaderStyle-Width="20px" HeaderText="ID" Visible="false" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="140px" ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Giới tính</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:DropDownList ID="ddlGioitinhDNK" CssClass="chosen-select" runat="server" AutoPostBack="true" Width="120px" SelectedValue='<%# Bind("GIOITINH") %>'>
                                                            <asp:ListItem Value="-1" Text="--Chọn--"></asp:ListItem>
                                                            <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                                                            <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="250px" ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Người khiếu nại</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtHoten" runat="server" Text='<%# Eval("HOTEN")%>' CssClass="user" Width="97.5%" MaxLength="250"></asp:TextBox>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Địa chỉ người khiếu nại</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtDiachi" runat="server" Text='<%# Eval("DIACHI")%>' CssClass="user" Width="98%" MaxLength="250"></asp:TextBox>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                            </Columns>
                                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        </asp:DataGrid>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </asp:Panel>
                <asp:Panel ID="pnDonTrung" runat="server" Visible="false">
                    <div class="boxchung">
                        <h4 class="tleboxchung">Thêm đơn trùng</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <tr>
                                    <td class="DonGDTCol1">Số đơn trùng</td>
                                    <td>
                                        <asp:DropDownList ID="ddlSoLuong" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlSoLuong_SelectedIndexChanged"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                            PageSize="10" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                            ItemStyle-CssClass="chan" OnItemDataBound="dgList_ItemDataBound">
                                            <Columns>
                                                <asp:BoundColumn DataField="TT" HeaderStyle-Width="20px" HeaderText="STT" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="60px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Số hiệu đơn</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtSohieudon" runat="server" Text='<%# Eval("SOHIEUDON")%>' CssClass="user" Width="60px" MaxLength="10"></asp:TextBox>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Ngày nhận đơn</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <%--  <asp:TextBox ID="txtNgaynhandon" runat="server" Text='<%# Eval("NGAYNHANDON")%>' CssClass="user" Width="75px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="txtNgaynhandon_CalendarExtender" runat="server" TargetControlID="txtNgaynhandon" Format="dd/MM/yyyy" />
                                                        <cc1:MaskedEditExtender ID="txtNgaynhandon_MaskedEditExtender3" runat="server" TargetControlID="txtNgaynhandon" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" Century="2000" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />--%>
                                                        <asp:TextBox ID="txtNgaynhandon" runat="server" CssClass="user"
                                                            Text='<%# Eval("NGAYNHANDON")%>' Width="75px"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="txtNgaynhandon_CalendarExtender" runat="server" TargetControlID="txtNgaynhandon"
                                                            Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="txtNgaynhandon_MaskedEditExtender3" runat="server" TargetControlID="txtNgaynhandon"
                                                            Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Ngày ghi trên đơn</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtNgayghitrendon" runat="server" Text='<%# Eval("NGAYGHIDON")%>' CssClass="user" Width="75px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="txtNgayghitrendon_CalendarExtender" runat="server" TargetControlID="txtNgayghitrendon" Format="dd/MM/yyyy" />
                                                        <cc1:MaskedEditExtender ID="txtNgayghitrendon_MaskedEditExtender3" runat="server" TargetControlID="txtNgayghitrendon" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" Century="2000" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="50px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Công văn?</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="chkIsCV" runat="server" AutoPostBack="true" Checked='<%# GetNumber(Eval("HINHTHUCDON"))%>'
                                                            ToolTip='<%#Eval("TT")%>' OnCheckedChanged="chkIsCV_CheckedChanged" />
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Số công văn</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtSoCV" Visible="false" runat="server" CssClass="user" Width="65px" MaxLength="50"></asp:TextBox>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Ngày CV</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtNgayCV" Visible="false" runat="server" Text='<%# Eval("NGAYGHIDON")%>' CssClass="user" Width="75px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="txtNgayCV_CalendarExtender" runat="server" TargetControlID="txtNgayCV" Format="dd/MM/yyyy" />
                                                        <cc1:MaskedEditExtender ID="txtNgayCV_MaskedEditExtender3" runat="server" TargetControlID="txtNgayCV" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" Century="2000" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="50px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Trong ngành?</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="chkIsTrongnganh" Visible="false" runat="server" AutoPostBack="true" Checked='<%# GetNumber(Eval("LOAIDONVI"))%>'
                                                            ToolTip='<%#Eval("TT")%>' OnCheckedChanged="chkIsTrongnganh_CheckedChanged" />
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="250px" ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Đơn vị gửi  </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtDonvi" Visible="false" runat="server" CssClass="user" Width="242px" MaxLength="250"></asp:TextBox>
                                                        <asp:DropDownList ID="ddlDonvi" Visible="false" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                            </Columns>
                                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        </asp:DataGrid>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </asp:Panel>
                <%-- //------------------%>
                <div class="boxchung">
                    <h4 class="tleboxchung">
                        <asp:Label ID="TTChuyenDon" runat="server" Text="Thông tin chuyển đơn"></asp:Label>
                    </h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td style="width: 150px;">Nơi chuyển đến</td>
                                <td colspan="3" style="width: 500px;">
                                    <asp:RadioButtonList ID="rdbLoaichuyen" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbLoaichuyen_SelectedIndexChanged">
                                        <asp:ListItem Value="0" Text="Nội bộ" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Tòa khác"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Ngoài tòa án"></asp:ListItem>
                                        <asp:ListItem Value="3" Text="Trả lại đơn"></asp:ListItem>
                                        <asp:ListItem Value="4" Text="Xếp đơn"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                                <td style="width: 100px;">
                                    <asp:Label ID="lblNgayXuLy" runat="server" Text="Ngày xử lý đơn"></asp:Label></td>
                                <td>
                                    <asp:TextBox ID="txtNgayXuLy" Style="text-align: right;" Enabled="false" runat="server" CssClass="user" Width="100px" MaxLength="50"></asp:TextBox>
                                </td>
                            </tr>
                            <tr style="display: none;">
                                <td>Phân loại xử lý<span class="batbuoc">*</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlPhanloai" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="true" OnSelectedIndexChanged="ddlPhanloai_SelectedIndexChanged">
                                        <asp:ListItem Value="1" Text="Đơn mới" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Đơn khiếu nại sau khi đã giải quyết"></asp:ListItem>
                                        <asp:ListItem Value="3" Text="Đơn trùng"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td></td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtSoLuongDon" Visible="false" Style="text-align: right;" Enabled="false" runat="server" CssClass="user" Width="175px" MaxLength="50"></asp:TextBox>
                                </td>
                            </tr>
                            <asp:Panel ID="pnNoibo_vb" runat="server">
                                <tr>
                                    <td colspan="6">
                                        <div style="float: left; margin-top: 15px;">
                                            <div style="width: 164px; float: left;">Đơn vị chuyển đến</div>
                                            <div style="float: left;">
                                                <asp:DropDownList ID="ddlChuyendenDV_VB" CssClass="chosen-select" runat="server" Width="478px" AutoPostBack="True">
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6">
                                        <div style="float: left;">
                                            <div style="width: 164px; float: left; margin-top: 4px;">Ngày chuyển</div>
                                            <div style="float: left">
                                                <asp:TextBox ID="txtNgayChuyen_VB" runat="server" CssClass="user" Width="112px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender13" runat="server" TargetControlID="txtNgayChuyen_VB" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender13" runat="server" TargetControlID="txtNgayChuyen_VB" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <asp:Panel ID="pnlLoaiAn" runat="server">
                                <tr>
                                    <td>
                                        <asp:Label ID="lblLoaiAn" runat="server" Text="Loại án"></asp:Label><span class="batbuoc">*</span>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select" runat="server" Width="250px"
                                            AutoPostBack="True" OnSelectedIndexChanged="ddlLoaiAn_SelectedIndexChanged">
                                        </asp:DropDownList>

                                    </td>
                                </tr>
                            </asp:Panel>
                            <asp:Panel ID="pnNoibo" runat="server">
                                <tr>
                                    <td>Đơn vị chuyển đến<span class="batbuoc">*</span></td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddlChuyendenDV" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlChuyendenDV_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="trTuHinh" runat="server">
                                    <td></td>
                                    <td colspan="5" style="padding-top: 7px; padding-bottom: 7px;">
                                        <asp:CheckBox ID="chkIsTuHinh" runat="server" Text="Án tử hình" AutoPostBack="True" OnCheckedChanged="chkIsTuHinh_CheckedChanged" />
                                        &nbsp;&nbsp;&nbsp;&nbsp;
                                        <asp:CheckBox ID="chkIsAnGiam" Visible="false" runat="server" Text="Xin ân giảm án tử hình" />
                                        &nbsp;
                                        <asp:CheckBox ID="chkKeuOan" Visible="false" runat="server" Text="Kêu oan án tử hình" />
                                    </td>
                                </tr>
                                <tr runat="server" id="trTrangthaidon">
                                    <td class="DonGDTCol1">Trạng thái đơn</td>
                                    <td class="DonGDTCol2">
                                        <asp:DropDownList ID="ddlTrangthaidon" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlTrangthaidon_SelectedIndexChanged">
                                            <asp:ListItem Value="0" Text="Đơn đủ điều kiện" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Đơn chưa đủ điều kiện"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td class="DonGDTCol3">
                                        <asp:Label ID="lblLydoCDDK" runat="server" Text="Thụ lý đơn"></asp:Label>
                                    </td>
                                    <td colspan="3">
                                        <asp:CheckBoxList ID="chkLydoCDDK" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" Visible="false" AutoPostBack="True" OnSelectedIndexChanged="chkLydoCDDK_SelectedIndexChanged">
                                            <asp:ListItem Value="0" Text="Bản án, quyết định"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Xác nhận"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Lý do khác"></asp:ListItem>
                                        </asp:CheckBoxList>

                                        <asp:RadioButtonList ID="rdbThuLy" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rdbThuLy_SelectedIndexChanged">
                                            <asp:ListItem Value="1" Text="Thụ lý mới" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Đã thụ lý"></asp:ListItem>
                                            <%--  <asp:ListItem Value="3" Text="Thụ lý lại"></asp:ListItem>--%>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr runat="server" id="trLydokhac" visible="false">
                                    <td colspan="6">
                                        <asp:TextBox ID="txtLydoCDDK_Khac" runat="server" CssClass="user" TextMode="MultiLine" Width="88%" Rows="3" MaxLength="2000"></asp:TextBox>
                                    </td>
                                </tr>
                                <asp:Panel ID="pnThuLy" Visible="true" runat="server">
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblSoThuly" runat="server" Text="Số thụ lý"></asp:Label>
                                            <span class="batbuoc">*</span></td>
                                        <td>
                                            <asp:TextBox ID="txtSoThuLy" runat="server" CssClass="user" Width="242px" MaxLength="50"></asp:TextBox>

                                        </td>
                                        <td>
                                            <asp:Label ID="lblNgaythuly" runat="server" Text=" Ngày thụ lý đơn"></asp:Label>
                                            <span class="batbuoc">*</span></td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtNgaythuly" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtNgaythuly" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtNgaythuly" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr style="display: none;">

                                        <td>Người thụ lý</td>
                                        <td>
                                            <asp:DropDownList ID="ddlNguoiThuly" CssClass="chosen-select" runat="server" Width="250px">
                                            </asp:DropDownList></td>
                                        <td></td>
                                        <td colspan="3"></td>
                                    </tr>
                                </asp:Panel>
                                <tr>
                                    <td>Ghi chú</td>
                                    <td colspan="5">
                                        <asp:TextBox ID="txt_GHICHU_TTCD" runat="server" CssClass="user" Width="621px"></asp:TextBox></td>
                                </tr>
                            </asp:Panel>
                            <asp:Panel ID="pnToakhac" Visible="false" runat="server">
                                <tr>
                                    <td class="DonGDTCol1">Đơn vị chuyển đến<span class="batbuoc">*</span></td>
                                    <td class="DonGDTCol2">
                                        <asp:DropDownList ID="ddlToaKhac" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>

                                    </td>
                                    <td class="DonGDTCol3">Đơn gửi tới</td>
                                    <td colspan="3">
                                        <asp:RadioButtonList ID="rdbDonguitoi" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem Value="0" Text="TA" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="CA"></asp:ListItem>
                                        </asp:RadioButtonList></td>
                                </tr>
                            </asp:Panel>
                            <asp:Panel ID="pnNgoaitoaan" Visible="false" runat="server">
                                <tr>
                                    <td class="DonGDTCol1">Đơn vị chuyển đến<span class="batbuoc">*</span></td>
                                    <td colspan="5">
                                        <asp:TextBox ID="txtNgoaitoaan" CssClass="user" runat="server" Width="625px"></asp:TextBox>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <asp:Panel ID="pnTralaidon" Visible="false" runat="server">
                                <tr>
                                    <td class="DonGDTCol1">Lý do trả lại</td>
                                    <td class="DonGDTCol2">
                                        <asp:DropDownList ID="ddlLydotralai" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlLydotralai_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </td>
                                    <td class="DonGDTCol3">
                                        <asp:Label ID="lblLydokhac" runat="server" Visible="false" Text="Lý do khác"></asp:Label>
                                    </td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtTralaikhac" Visible="false" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Yêu cầu</td>
                                    <td colspan="5">
                                        <asp:TextBox ID="txtTralaiYeucau" runat="server" CssClass="user" Width="625px"></asp:TextBox></td>
                                </tr>
                                <tr style="display: none;">
                                    <td>Số phiếu trả lại</td>
                                    <td>
                                        <asp:TextBox ID="txtTralaiSophieu" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>
                                    <td>Ngày trả lại</td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtTralaiNgay" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtTralaiNgay" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtTralaiNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                    </td>
                                </tr>
                            </asp:Panel>
                        </table>
                    </div>
                </div>
                <div class="boxchung" runat="server" id="KN_BiCao">
                    <h4 class="tleboxchung">
                        <asp:Label ID="lbl_KN_BC" runat="server" Text="Bị cáo, Người khiếu nại"></asp:Label></h4>
                    <div class="boder" style="padding: 10px;">
                        <asp:Panel runat="server" ID="BC_NKN_HS" Visible="true">
                            <table class="table1">
                                <tr>
                                    <td>
                                        <div style="float: left; width: 120px; text-align: right; margin-top: 3px;">Người khiếu nại</div>
                                        <div style="float: left; margin-left: 7px;">
                                            <asp:DropDownList ID="dropNguoiKhieuNai" runat="server" CssClass="chosen-select" Width="250px"
                                                AutoPostBack="true" OnSelectedIndexChanged="dropNguoiKhieuNai_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </div>
                                        <div style="float: left; margin-left: 7px;">
                                            <asp:LinkButton ID="lkThemNguoiKN" runat="server" OnClick="lkThemNguoiKN_Click"
                                                CssClass="button_empty" ToolTip="Tạo người KN">Thêm</asp:LinkButton>
                                        </div>
                                        <div style="float: left; color: red; font-size: 15px; text-align: center; margin-left: 35px;">
                                            <asp:Literal ID="lttMsgBC_NKN" runat="server"></asp:Literal>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="float: left; width: 120px; text-align: right; margin-top: 3px;">Người được khiếu nại</div>
                                        <div style="float: left; margin-left: 7px;">
                                            <asp:DropDownList ID="dropBiCao" runat="server" Width="250px" CssClass="chosen-select"
                                                OnSelectedIndexChanged="dropBiCao_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </div>
                                        <div style="float: left; margin-left: 7px;">
                                            <asp:LinkButton ID="lkThem_BC" runat="server" OnClick="lkThemBiCao_Click"
                                                CssClass="button_empty" ToolTip="Thêm bị bị cáo">Thêm</asp:LinkButton>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="float: left; width: 120px; text-align: right; margin-top: 3px;">Nội dung khiếu nại</div>
                                        <div style="float: left; margin-left: 7px;">
                                            <asp:TextBox ID="txtNguoiKN_NoiDung" CssClass="user" runat="server" Width="606px"></asp:TextBox>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="color: red; font-size: 15px; text-align: center;">
                                            <asp:Literal ID="lttMsgBC" runat="server"></asp:Literal>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="float: left; margin-left: 125px; margin-top: 11px;">
                                            <div style="float: left">
                                                <asp:Button ID="cmdSaveDSHinhSu" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdSaveDSHinhSu_Click" />
                                            </div>
                                            <div style="float: left; margin-left: 7px;">
                                                <asp:Button ID="cmdRefresh" runat="server" CssClass="buttoninput" Text="Làm mới"
                                                    OnClick="cmdRefresh_Click" />
                                            </div>
                                            <div style="display: none;">
                                                <asp:Button ID="cmd_load_dstd_cc" runat="server" CssClass="buttoninput" Text="Làm mới"
                                                    OnClick="cmd_load_dstd_cc_Click" />
                                            </div>
                                        </div>

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table class="table2" width="100%" border="1">
                                            <tr class="header">
                                                <td width="42">
                                                    <div align="center"><strong>TT</strong></div>
                                                </td>
                                                <td width="150px">
                                                    <div align="center"><strong>Họ tên</strong></div>
                                                </td>
                                                <td>
                                                    <div align="center"><strong>Thông tin Bị cáo, Tội danh, mức án</strong></div>
                                                </td>
                                                <td width="70px">
                                                    <div align="center"><strong>Thao tác</strong></div>
                                                </td>
                                            </tr>
                                            <asp:Repeater ID="rptBiCao" runat="server"
                                                OnItemDataBound="rptBiCao_ItemDataBound"
                                                OnItemCommand="rptBiCao_ItemCommand">
                                                <ItemTemplate>
                                                    <tr>
                                                        <td>
                                                            <div align="center"><%# Container.ItemIndex + 1 %></div>
                                                        </td>
                                                        <td>
                                                            <asp:Literal ID="lttTenDS" runat="server"></asp:Literal>

                                                        </td>
                                                        <td runat="server">
                                                            <asp:Literal ID="lttBiCao" runat="server"></asp:Literal>
                                                            <asp:Repeater ID="rptBCKN" runat="server" OnItemCommand="RptBCKN_ItemCommand">
                                                                <HeaderTemplate>
                                                                    <div class="listbc">
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <div class="listbc_item" style="position: relative;">
                                                                        <div style="float: left; width: 30%; font-weight: bold;">
                                                                            <%# Container.ItemIndex + 1 %><%# ". "
                                                                              + Eval("BiCao_TuCachTT")
                                                                              + " "+ (String.IsNullOrEmpty(Eval("BiCaoName")+"")?"Khác":Eval("BiCaoName")+"") %>
                                                                        </div>
                                                                        <div style="float: left; margin-left: 1%; width: 58%;">
                                                                            <%#String.IsNullOrEmpty(Eval("Hs_MucAn") +"")?"":("Mức án:"+Eval("Hs_MucAn")+"") %>

                                                                            <div style="float: left; width: 100%;">
                                                                                <%#String.IsNullOrEmpty(Eval("ListToiDanhBC") +"")?"":("Tội danh:"+Eval("ListToiDanhBC")+"") %>
                                                                            </div>
                                                                            <div style="float: left; width: 100%;">
                                                                                <%#String.IsNullOrEmpty(Eval("NoiDungKhieuNai") +"")?"":("Khiếu nại: "+Eval("NoiDungKhieuNai")) %>
                                                                            </div>
                                                                        </div>
                                                                        <div style="position: absolute; right: -76px; width: 69px; text-align: center; margin-top: 10px;">
                                                                            <asp:LinkButton ID="lkSuaKN" runat="server"
                                                                                Text="Sửa" ForeColor="#0e7eee"
                                                                                CommandName="SuaKN" CommandArgument='<%#Eval("ID")+"$"+ Eval("NguoiKhieuNaiID")+"$"+Eval("BiCaoID")+"$"+Eval("NoiDungKhieuNai")%>'></asp:LinkButton>
                                                                            &nbsp;&nbsp;
                                                                             <asp:LinkButton ID="lbtXoaKN" runat="server" CausesValidation="false"
                                                                                 Text="Xóa" ForeColor="#0e7eee"
                                                                                 CommandName="XoaKN" CommandArgument='<%#Eval("ID") %>'
                                                                                 OnClientClick="return confirm('Bạn thực sự muốn xóa khiếu nại cho bị cáo này? ');"></asp:LinkButton>
                                                                        </div>
                                                                    </div>
                                                                </ItemTemplate>
                                                                <FooterTemplate></div></FooterTemplate>
                                                            </asp:Repeater>
                                                        </td>
                                                        <td>
                                                            <div id="td_sua_div" runat="server" align="center" style="width: 69px;">
                                                                <div style="float: left; margin-left: 3px;">
                                                                    <asp:Literal ID="lttSua" runat="server"></asp:Literal>
                                                                </div>
                                                                <div style="display: none;">
                                                                    <asp:LinkButton ID="lkSua" runat="server"
                                                                        Text="Sửa" ForeColor="#0e7eee"
                                                                        CommandName="Sua" CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                                </div>
                                                                &nbsp;&nbsp;
                                                            <div style="float: left; margin-left: 15px;">
                                                                <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false"
                                                                    Text="Xóa" ForeColor="#0e7eee"
                                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                    OnClientClick="return confirm('Bạn thực sự muốn xóa Bị cáo này? ');"></asp:LinkButton>
                                                            </div>
                                                                <br />
                                                                <div style="margin-top: 3px;">
                                                                    <asp:Literal ID="ltt_them_td" runat="server"></asp:Literal>
                                                                </div>
                                                                <div style="display: none;">
                                                                    <asp:LinkButton ID="lbtthem_td" runat="server" CausesValidation="false"
                                                                        Text="Thêm tội danh" ForeColor="#0e7eee"
                                                                        CommandName="them_td" CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:Panel runat="server" ID="BC_NKN_DS" Visible="false">
                            <table class="table1" style="width: 70%;">
                                <tr>
                                    <td>
                                        <div style="margin: 5px; width: 95%; color: red;">
                                            <asp:Label ID="lttMsg" runat="server"></asp:Label>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="float: left; width: 155px; margin-top: 4px;">Quan hệ pháp luật<span class="batbuoc">*</span></div>
                                        <div style="float: left;">
                                            <asp:TextBox ID="txt_QHPL" CssClass="user" runat="server" Width="616px"></asp:TextBox>
                                        </div>
                                    </td>
                                </tr>
                                <!----------------------------->
                                <asp:Panel ID="pnNguyenDon" runat="server">
                                    <tr>
                                        <td colspan="4" style="height: 5px;"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4"><b style="margin-right: 10px;">Nguyên đơn/ Người khởi kiện</b>
                                            <asp:HiddenField ID="hddSoND" runat="server" Value="1" />
                                            <asp:LinkButton ID="lkThemND" runat="server" CssClass="buttonpopup them_user clear_bottom" ToolTip="Thêm Nguyên đơn/ Người khởi kiện"
                                                OnClientClick="return validate();" OnClick="lkThemND_Click">&nbsp;</asp:LinkButton>
                                            <asp:CheckBox ID="chkND" runat="server" Text="Có địa chỉ"
                                                AutoPostBack="true" OnCheckedChanged="chkND_CheckedChanged" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" style="vertical-align: top;">
                                            <asp:Repeater ID="rptNguyenDon" runat="server" OnItemCommand="rptNguyenDon_ItemCommand" OnItemDataBound="rptNguyenDon_ItemDataBound">
                                                <HeaderTemplate>
                                                    <table class="table_list" width="100%" border="1">
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr>
                                                        <td width="15px" style="text-align: center;">
                                                            <asp:HiddenField ID="hddDuongSuID" runat="server" Value='<%#Eval("ID") %>' />
                                                            <%# Container.ItemIndex + 1 %></td>
                                                        <td>
                                                            <asp:TextBox ID="txtTen" Width="96%" CssClass="user"
                                                                placeholder="Họ tên(*)"
                                                                runat="server" Text='<%#Eval("TenDuongSu") %>'></asp:TextBox></td>

                                                        <asp:Panel ID="pn_diachi" runat="server">
                                                            <td width="250px">
                                                                <asp:HiddenField ID="hddHuyenID" runat="server" Value='<%# Eval("HUYENID") %>' />
                                                                <asp:DropDownList ID="ddlTinhHuyen" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                            </td>
                                                            <td width="190px">
                                                                <asp:TextBox ID="txtDiachi" Width="96%"
                                                                    placeholder="Địa chỉ chi tiết"
                                                                    CssClass="user" runat="server"
                                                                    Text='<%# Eval("DiaChi") %>'></asp:TextBox></td>
                                                        </asp:Panel>
                                                        <td width="30px">
                                                            <div align="center">
                                                                <asp:LinkButton ID="lkXoa" Visible='<%#(Convert.ToInt16(Eval("IsDelete")+"")==0)? false:true %>' runat="server"
                                                                    CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                    ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                                <FooterTemplate></table></FooterTemplate>
                                            </asp:Repeater>

                                        </td>
                                    </tr>
                                </asp:Panel>

                                <!----------------------------->
                                <asp:Panel ID="pnBiDon" runat="server">
                                    <tr>
                                        <td colspan="4" style="height: 5px;"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4"><b style="margin-right: 10px;">Bị đơn/ Người  bị kiện</b>
                                            <asp:HiddenField ID="hddSoBD" runat="server" Value="1" />

                                            <asp:LinkButton ID="lkThemBD" runat="server" CssClass="buttonpopup them_user clear_bottom" ToolTip="Thêm bị đơn/ Người bị kiện"
                                                OnClientClick="return validate();" OnClick="lkThemBD_Click">&nbsp;</asp:LinkButton>
                                            <asp:CheckBox ID="chkBD" runat="server" Text="Có địa chỉ"
                                                AutoPostBack="true" OnCheckedChanged="chkBD_CheckedChanged" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" style="vertical-align: top;">

                                            <asp:Repeater ID="rptBiDon" runat="server"
                                                OnItemCommand="rptBiDon_ItemCommand" OnItemDataBound="rptBiDon_ItemDataBound">
                                                <HeaderTemplate>
                                                    <table class="table_list" width="100%" border="1">
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr>
                                                        <td width="15px" style="text-align: center;">
                                                            <asp:HiddenField ID="hddDuongSuID" runat="server" Value='<%#Eval("ID") %>' />
                                                            <%# Container.ItemIndex + 1 %></td>
                                                        <td>
                                                            <asp:TextBox ID="txtTen" Width="96%" CssClass="user"
                                                                placeholder="Họ tên bị đơn (*)"
                                                                runat="server" Text='<%#Eval("TenDuongSu") %>'></asp:TextBox></td>
                                                        <asp:Panel ID="pn_diachi" runat="server">
                                                            <td width="250px">
                                                                <asp:HiddenField ID="hddHuyenID" runat="server" Value='<%# Eval("HUYENID") %>' />
                                                                <asp:DropDownList ID="ddlTinhHuyen" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                            </td>
                                                            <td width="190px">
                                                                <asp:TextBox ID="txtDiachi" Width="96%"
                                                                    placeholder="Địa chỉ chi tiết"
                                                                    CssClass="user" runat="server"
                                                                    Text='<%# Eval("DiaChi") %>'></asp:TextBox></td>
                                                        </asp:Panel>
                                                        <td width="30px">
                                                            <div align="center">
                                                                <asp:LinkButton ID="lkXoa" Visible='<%#(Convert.ToInt16(Eval("IsDelete")+"")==0)? false:true %>' runat="server"
                                                                    CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                    ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                                <FooterTemplate></table></FooterTemplate>
                                            </asp:Repeater>

                                        </td>
                                    </tr>
                                </asp:Panel>

                                <!----------------------------->
                                <asp:Panel ID="pnDsKhac" runat="server">
                                    <tr>
                                        <td colspan="4" style="height: 5px;"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4"><b style="margin-right: 10px;">Người có QL&NVLQ</b>

                                            <asp:HiddenField ID="hddSoDSKhac" runat="server" Value="0" />
                                            <asp:LinkButton ID="lkThemDSKhac" runat="server" CssClass="buttonpopup them_user clear_bottom" ToolTip="Thêm Người có QL&NVLQ"
                                                OnClientClick="return validate();" OnClick="lkThemDSKhac_Click">&nbsp;</asp:LinkButton>
                                            <asp:CheckBox ID="chkDSKhac" runat="server" Text="Có địa chỉ"
                                                AutoPostBack="true" OnCheckedChanged="chkDSKhac_CheckedChanged" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <asp:Repeater ID="rptDsKhac" runat="server"
                                                OnItemCommand="rptDsKhac_ItemCommand" OnItemDataBound="rptDsKhac_ItemDataBound">
                                                <HeaderTemplate>
                                                    <table class="table_list" width="100%" border="1">
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr>
                                                        <td style="text-align: center; width: 15px;">
                                                            <asp:HiddenField ID="hddDuongSuID" runat="server" Value='<%#Eval("ID") %>' />
                                                            <%# Container.ItemIndex + 1 %></td>
                                                        <td>
                                                            <asp:TextBox ID="txtTen" Width="96%" CssClass="user"
                                                                placeholder="Họ tên"
                                                                runat="server" Text='<%#Eval("TenDuongSu") %>'></asp:TextBox></td>
                                                        <asp:Panel ID="pn_diachi" runat="server">
                                                            <td width="250px">
                                                                <asp:HiddenField ID="hddHuyenID" runat="server" Value='<%# Eval("HUYENID") %>' />
                                                                <asp:DropDownList ID="ddlTinhHuyen" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                            </td>
                                                            <td width="190px">
                                                                <asp:TextBox ID="txtDiachi" Width="96%"
                                                                    placeholder="Địa chỉ chi tiết"
                                                                    CssClass="user" runat="server"
                                                                    Text='<%# Eval("DiaChi") %>'></asp:TextBox></td>
                                                        </asp:Panel>
                                                        <td width="30px">
                                                            <div align="center">
                                                                <asp:LinkButton ID="lkXoa" Visible='<%#(Convert.ToInt16(Eval("IsDelete")+"")==0)? false:true %>' runat="server"
                                                                    CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"
                                                                    OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                                <FooterTemplate></table></FooterTemplate>
                                            </asp:Repeater>
                                        </td>
                                    </tr>
                                </asp:Panel>
                            </table>
                        </asp:Panel>
                    </div>

                </div>
                <%--//------------------------%>
                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                    <asp:Label ID="lstMsgB" Font-Size="17px" runat="server"></asp:Label>
                </div>
                <div runat="server" id="divCommandB" style="margin: 5px; text-align: center; width: 95%">
                    <asp:Button ID="cmdUpdateB" runat="server" CssClass="buttoninput" Text="Lưu"
                        OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                    <asp:Button ID="cmdUpdateAndNewB" runat="server" CssClass="buttoninput" Text="Lưu & Thêm mới" OnClick="cmdUpdateAndNew_Click" />
                    <asp:Button ID="cmdLamMoiB" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLamMoi_Click" />
                    <asp:Button ID="cmdQuaylaiB" runat="server" CssClass="buttoninput" Text="Quay lại"
                        OnClick="cmdQuaylai_Click" />
                </div>

                <asp:Panel ID="pnDSTrung" runat="server" Visible="false">
                    <div class="boxchung">
                        <h4 class="tleboxchung">Danh sách đơn trùng</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <tr>
                                    <td>
                                        <asp:HiddenField ID="hddTotalPageDT" Value="1" runat="server" />
                                        <asp:HiddenField ID="hddPageIndexDT" Value="1" runat="server" />
                                        <div class="phantrang">
                                            <div class="sobanghi" style="display: none;">
                                                <asp:Literal ID="lstSobanghiTDT" runat="server"></asp:Literal>
                                            </div>
                                            <div class="sotrang">
                                                <asp:LinkButton ID="lbTBackDT" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                                    OnClick="lbTBackDT_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTFirstDT" runat="server" CausesValidation="false" CssClass="active" Visible="true"
                                                    Text="1" OnClick="lbTFirstDT_Click"></asp:LinkButton>
                                                <asp:Label ID="lbTStep1DT" runat="server" Text="..." Visible="false"></asp:Label>
                                                <asp:LinkButton ID="lbTStep2DT" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="2" OnClick="lbTStepDT_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTStep3DT" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="3" OnClick="lbTStepDT_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTStep4DT" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="4" OnClick="lbTStepDT_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTStep5DT" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="5" OnClick="lbTStepDT_Click"></asp:LinkButton>
                                                <asp:Label ID="lbTStep6DT" runat="server" Text="..." Visible="false"></asp:Label>
                                                <asp:LinkButton ID="lbTLastDT" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="100" OnClick="lbTLastDT_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTNextDT" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                                    OnClick="lbTNextDT_Click"></asp:LinkButton>
                                            </div>
                                        </div>
                                        <asp:DataGrid ID="dgDSDonTrung" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                            PageSize="5" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                            ItemStyle-CssClass="chan" OnItemCommand="dgDSDonTrung_ItemCommand">
                                            <Columns>
                                                <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>TT</HeaderTemplate>
                                                    <ItemTemplate><%# Container.ItemIndex + 1 %></ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:BoundColumn DataField="SOHIEUDON" HeaderText="Số hiệu" HeaderStyle-Width="50px"></asp:BoundColumn>
                                                <asp:BoundColumn DataField="NGAYNHANDON" HeaderText="Ngày nhận" HeaderStyle-Width="60px" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                                <asp:BoundColumn DataField="NGAYGHITRENDON" HeaderText="Ngày ghi trên đơn" HeaderStyle-Width="60px" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="170px" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Người gửi</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <b><%#Eval("DONGKHIEUNAI") %></b><br />
                                                        <i><%#Eval("Diachigui") %></i>
                                                        <br />
                                                        <%# (Eval("arrCongvan")+"")=="" ? "":"(" + Eval("arrCongvan") + ")" %>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                    <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-HorizontalAlign="Left">
                                                    <HeaderTemplate>Nơi chuyển đến</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <b style="color: #0e7eee;"><%#Eval("TRANGTHAICHUYEN") %>:</b></i>  <b><%#Eval("NOICHUYEN") %></b> <i>(Số <%#Eval("CD_SOCV") %> - <%# GetDate(Eval("CD_NGAYCV")) %>)</i>
                                                        <br />
                                                        <div style='width: 100%; display: <%#Eval("IsShowNB") %>'>
                                                            <div style='width: 100%; display: <%#Eval("IsShowDDK") %>'>
                                                                <div style='width: 100%; display: <%#Eval("IsShowTLMOI") %>'>
                                                                    <b>Thụ lý mới</b><br />
                                                                    <i>Số: </i><%#Eval("TL_SO") %> - <%# GetDate(Eval("TL_NGAY")) %>
                                                                    <br />
                                                                    <i>Thẩm phán</i><br />
                                                                    <b><%#Eval("TENTHAMPHAN") %></b>
                                                                </div>
                                                                <div style='width: 100%; display: <%#Eval("IsShowDATL") %>'>
                                                                    <b>Đã thụ lý</b>
                                                                </div>
                                                            </div>
                                                            <div style='width: 100%; display: <%#Eval("IsShowCDDK") %>'>
                                                                <b>Đơn chưa đủ điều kiện</b>
                                                                <i>TB YCBS số: </i><%#Eval("TB1_SO") %> &nbsp;<i>Ngày: </i><%# GetDate(Eval("TB1_NGAY")) %> </b>
                                                            </div>
                                                        </div>
                                                        <div style='width: 100%; display: <%#Eval("IsShowTK") %>'>
                                                            <b>Chuyển đơn</b>
                                                        </div>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                    <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Kết quả giải quyết</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <%#Eval("CV_TRALOI_NOIDUNG") %>
                                                        <br />
                                                        <%#Eval("GHICHU") %>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                    <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Người nhập</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <b><%#Eval("NguoiNhap") %></b><br />
                                                        <%# Convert.ToDateTime(Eval("NgayNhap")).ToString("dd/MM/yyyy HH:mm") %>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                    <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Sửa</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <div class="tooltip">
                                                            <asp:ImageButton ID="cmdEdit" runat="server" ToolTip="Sửa" CssClass="grid_button"
                                                                CommandName="Sua" CommandArgument='<%#Eval("ID") %>'
                                                                ImageUrl="~/UI/img/edit_doc.png" Width="18px" />
                                                            <span class="tooltiptext  tooltip-bottom">Sửa đơn</span>
                                                        </div>

                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Hủy trùng</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <div class="tooltip">
                                                            <asp:ImageButton ID="cmdXoa" runat="server" ToolTip="Hủy trùng đơn" CssClass="grid_button"
                                                                CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                ImageUrl="~/UI/img/delete.png" Width="17px"
                                                                OnClientClick="return confirm('Bạn thực sự muốn hủy trùng đơn? ');" />
                                                            <span class="tooltiptext  tooltip-bottom">Hủy trùng</span>
                                                        </div>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                </asp:TemplateColumn>
                                            </Columns>
                                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        </asp:DataGrid>
                                        <div class="phantrang" style="display: none;">
                                            <div class="sobanghi" style="display: none;">
                                                <asp:Literal ID="lstSobanghiBDT" runat="server"></asp:Literal>
                                            </div>
                                            <div class="sotrang">
                                                <asp:LinkButton ID="lbBBackDT" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                                    OnClick="lbTBackDT_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBFirstDT" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                                    Text="1" OnClick="lbTFirstDT_Click"></asp:LinkButton>
                                                <asp:Label ID="lbBStep1DT" runat="server" Text="..." Visible="false"></asp:Label>
                                                <asp:LinkButton ID="lbBStep2DT" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="2" OnClick="lbTStepDT_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBStep3DT" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="3" OnClick="lbTStepDT_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBStep4DT" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="4" OnClick="lbTStepDT_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBStep5DT" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="5" OnClick="lbTStepDT_Click"></asp:LinkButton>
                                                <asp:Label ID="lbBStep6DT" runat="server" Text="..." Visible="false"></asp:Label>
                                                <asp:LinkButton ID="lbBLastDT" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="100" OnClick="lbTLastDT_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBNextDT" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                                    OnClick="lbTNextDT_Click"></asp:LinkButton>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </asp:Panel>
                <asp:Panel ID="pnBoSung" runat="server">
                    <div class="boxchung">
                        <h4 class="tleboxchung">Quá trình bổ sung tài liệu</h4>
                        <div class="boder" style="padding: 10px;">
                            <asp:DataGrid ID="dgDS" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="10" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" OnItemCommand="dgDS_ItemCommand">
                                <Columns>
                                    <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>TT</HeaderTemplate>
                                        <ItemTemplate><%# Container.ItemIndex + 1 %></ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="SOHIEU" HeaderText="Số hiệu" HeaderStyle-Width="50px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGAYBOSUNG" HeaderText="Ngày bổ sung" HeaderStyle-Width="60px" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="105px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Kết quả</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("TENTRANGTHAI") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="75px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thiếu Bản án?</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkBA" Enabled="false" runat="server" Checked='<%#GetBool(Eval("ISBA")) %>' />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="65px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thiếu xác nhận?</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkXacnhan" Enabled="false" runat="server" Checked='<%#GetBool(Eval("ISXACNHAN")) %>' />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="105px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Lý do khác</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkKhac" Enabled="false" runat="server" Checked='<%#GetBool(Eval("ISKHAC")) %>' />
                                            <br />
                                            <%#Eval("LYDOKHAC") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn ItemStyle-HorizontalAlign="Justify" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Ghi chú</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("GHICHU") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="35px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Xóa</HeaderTemplate>
                                        <ItemTemplate>
                                            <div class="tooltip">
                                                <asp:ImageButton ID="cmdXoa" runat="server" ToolTip="Xóa" CssClass="grid_button"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                    ImageUrl="~/UI/img/delete.png" Width="17px"
                                                    OnClientClick="return confirm('Bạn thực sự muốn xóa? ');" />
                                                <span class="tooltiptext  tooltip-bottom">Xóa</span>
                                            </div>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </div>
    </div>
    <script>
        function Loadds_td() {
            $("#<%= cmd_load_dstd_cc.ClientID %>").click();
        }
        function popup_them_td_cc(DuongSuID) {
            var link = "/QLAN/GDTTT/Hoso/popup/pp_ToiDanh_cc.aspx?duongsuid=" + DuongSuID;
            var width = 800;
            var height = 500;
            PopupCenter(link, "Thêm tội danh", width, height);
        }
    </script>

    <script type="text/javascript">
        function pageLoad(sender, args) {
            $(function () {
                var urldmCV = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/GDTGetCongVan") %>';
                $("[id$=txtCongVan]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldmCV, data: "{ 'q': '" + request.term + "','strToaAnID':'0'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                            success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                        });
                    },
                    select: function (e, i) { $("[id$=hddNhaclaiCVID]").val(i.item.val); }, minLength: 1
                });
                var urldmHanhchinh = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/GetDMHuyen") %>';

                $("[id$=txtNGHuyen]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldmHanhchinh, data: "{ 'q': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                            success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                        });
                    },
                    select: function (e, i) { $("[id$=hddNGDCID]").val(i.item.val); }, minLength: 1
                });


                $("[id$=txtCVDC]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldmHanhchinh, data: "{ 'q': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                            success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                        });
                    },
                    select: function (e, i) { $("[id$=hddCVDCID]").val(i.item.val); }, minLength: 1
                });

                var urldmCQNGOAI = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/GetCoQuan") %>';
                $("[id$=txtNgoaitoaan]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldmCQNGOAI, data: "{ 'q': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                            success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                        });
                    },
                    select: function (e, i) { }, minLength: 1
                });
                $("[id$=txtCV_DonViGuiNgoaiNganh]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldmCQNGOAI, data: "{ 'q': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                            success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                        });
                    },
                    select: function (e, i) { }, minLength: 1
                });


            });
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }

        }
    </script>
    <script>
        function popup_them_ND_BD(VuAnID) {
            var link = "/QLAN/GDTTT/Hoso/popup/pBiCao_cc.aspx?hsID=" + VuAnID;
            var width = 900;
            var height = 800;
            PopupCenter(link, "Cập nhật thông tin bị can", width, height);
        }
        function popup_edit_ND_BD(DUONGSUID) {
            var link = "/QLAN/GDTTT/Hoso/popup/pBiCao_cc.aspx?DS_ID=" + DUONGSUID;
            var width = 900;
            var height = 800;
            PopupCenter(link, "Cập nhật thông tin bị can", width, height);
        }
        function Loadds_bc() {
            $("#<%= cmd_loadbc.ClientID %>").click();
        }
       <%-- function Loadds_bc_check() {
             $("#<%= cmd_NguoiGui_check.ClientID %>").click();
        }--%>
</script>
    <script type="text/javascript">
        //function CallFunctionReload(isBack) {
        //    if (isBack == 1) { window.location.reload(true); }
        //    else {

        //        window.location.reload(false);
        //    }
        //}
        function OpenPopupCenter(pageURL, title, w, h) {
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            var targetWin = window.open(pageURL, title, 'toolbar=no,scrollbars=yes,resizable=yes,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }
    </script>
    <script type="text/javascript">
        function validate() {
            var rdbBAQD = 0;
            var vHinhthucdon = 0;
            var ddlHinhthucdon = document.getElementById('<%=ddlHinhthucdon.ClientID%>');
            vHinhthucdon = ddlHinhthucdon.options[ddlHinhthucdon.selectedIndex].value;
            var vddlTrangthaidon = document.getElementById('<%=ddlTrangthaidon.ClientID%>');
            var vTrangthaidon = vddlTrangthaidon.options[ddlTrangthaidon.selectedIndex].value;

            //var radioButtons = document.getElementById('<%=rdbBAQD.ClientID%>');
            var radioButtons = document.getElementsByName("<%=rdbBAQD.UniqueID%>");
            for (var x = 0; x < radioButtons.length; x++) {
                if (radioButtons[x].checked) {
                    rdbBAQD = radioButtons[x].value;
                }
            }
            if (rdbBAQD == 0 && vHinhthucdon != 8 && vHinhthucdon != 10 && vHinhthucdon != 5) {
                var txtSoQDBA = document.getElementById('<%=txtSoQDBA.ClientID%>');
                if (vTrangthaidon != '1') {
                    if (txtSoQDBA.value == '') {
                        alert('Chưa nhập số bản án. Hãy nhập lại!');
                        txtSoQDBA.focus();
                        return false;
                    }
                    var txtNgayBA = document.getElementById('<%=txtNgayBA.ClientID%>');
                    if (txtNgayBA.value == '') {
                        alert('Chưa nhập ngày bản án. Hãy nhập lại!');
                        txtNgayBA.focus();
                        return false;

                    }
                }


            }
            if (rdbBAQD == 3 && vHinhthucdon != 8 && vHinhthucdon != 10) {
                var txtSoQDBA = document.getElementById('<%=txtSoQDBA.ClientID%>');
                if (txtSoQDBA.value == '') {
                    alert('Chưa nhập số Công văn. Hãy nhập lại!');
                    txtSoQDBA.focus();
                    return false;
                }
                var txtNgayBA = document.getElementById('<%=txtNgayBA.ClientID%>');
                if (txtNgayBA.value == '') {
                    alert('Chưa nhập ngày Công văn. Hãy nhập lại!');
                    txtNgayBA.focus();
                    return false;

                }
            }
            if (rdbBAQD == 4) {
                var txtSoQDBA = document.getElementById('<%=txtSoQDBA.ClientID%>');
                if (txtSoQDBA.value == '') {
                    alert('Chưa nhập số Thông báo. Hãy nhập lại!');
                    txtSoQDBA.focus();
                    return false;
                }
                var txtNgayBA = document.getElementById('<%=txtNgayBA.ClientID%>');
                if (txtNgayBA.value == '') {
                    alert('Chưa nhập ngày Thông báo. Hãy nhập lại!');
                    txtNgayBA.focus();
                    return false;

                }
            } else {
                var txtSoQDKN = document.getElementById('<%=txtSoQDKN.ClientID%>');
                if (txtSoQDKN != null && txtSoQDKN.value == '') {
                    alert('Chưa nhập số quyết định. Hãy nhập lại!');
                    txtSoQDKN.focus();
                    return false;
                }
                var txtNgayKhangNghi = document.getElementById('<%=txtNgayKhangNghi.ClientID%>');
                if (txtNgayKhangNghi != null && txtNgayKhangNghi.value == '') {
                    alert('Chưa nhập ngày quyết định. Hãy nhập lại!');
                    txtNgayKhangNghi.focus();
                    return false;

                }
            }

            var txtNguoigui = document.getElementById('<%=txtNguoigui.ClientID%>');
            var LengthNguoiGui = txtNguoigui.value.trim().length;
            if (LengthNguoiGui == 0) {
                alert('Bạn chưa nhập người gửi. Hãy nhập lại!');
                txtNguoigui.focus();
                return false;
            }
            if (LengthNguoiGui > 250) {
                alert('Tên người gửi không quá 250 ký tự. Hãy nhập lại!');
                txtNguoigui.focus();
                return false;
            }
            var txtSoCMND = document.getElementById('<%=txtSoCMND.ClientID%>');
            if (txtSoCMND.value.trim().length > 50) {
                alert('Số CMND không quá 50 ký tự. Hãy nhập lại!');
                txtSoCMND.focus();
                return false;
            }


            //validate số điện thoại
            var txtSoDienThoai = document.getElementById('<%=txtSoDienThoai.ClientID%>');

            if (txtSoDienThoai.value != "") {
                if (txtSoDienThoai.value.trim().length > 50) {
                    alert('Số điện thoại không quá 15 ký tự. Hãy nhập lại!');
                    txtSoDienThoai.focus();
                    return false;
                }

                var vnf_regex = /((09|03|07|08|05)+([0-9]{8})\b)/g;

                if (vnf_regex.test(txtSoDienThoai.value) == false) {
                    alert('Số điện thoại không đúng định dạng. Hãy nhập lại!');

                    txtSoDienThoai.focus();
                    return false;
                }
            }


            var txtNgaynhandon = document.getElementById('<%=txtNgaynhandon.ClientID%>');
            if (!CheckDateTimeControl_KoSoSanhNgayHienTai(txtNgaynhandon, 'Ngày nhận đơn'))
                return false;

            //var LengthNgaynhandon = txtNgaynhandon.value.trim().length;
            //if (LengthNgaynhandon == 0) {
            //    alert('Bạn phải nhập ngày nhận đơn theo định dạng (dd/MM/yyyy). Hãy nhập lại!');
            //    txtNgaynhandon.focus();
            //    return false;
            //}
            //if (LengthNgaynhandon > 0) {
            //    var arr = txtNgaynhandon.value.split('/');
            //    var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
            //    if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
            //        alert('Bạn phải nhập ngày nhận đơn theo định dạng (dd/MM/yyyy). Hãy nhập lại!');
            //        txtNgaynhandon.focus();
            //        return false;
            //    }
            //}
            var txtNgayghidon = document.getElementById('<%=txtNgayghidon.ClientID%>');
            var LengthNgayghidon = txtNgayghidon.value.trim().length;
            //manhnh bo tam de Duy nhap
            //if (LengthNgayghidon == 0) {
            //    alert('Bạn phải nhập ngày ghi trên đơn theo định dạng (dd/MM/yyyy). Hãy nhập lại!');
            //    txtNgayghidon.focus();
            //    return false;
            //}
            //if (LengthNgayghidon > 0) {
            //    var arr = txtNgayghidon.value.split('/');
            //    var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
            //    if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
            //        alert('Bạn phải nhập ngày ghi trên đơn theo định dạng (dd/MM/yyyy). Hãy nhập lại!');
            //        txtNgayghidon.focus();
            //        return false;
            //    }
            //}


            var ddlHinhthucdon = document.getElementById('<%=ddlHinhthucdon.ClientID%>');
            val = ddlHinhthucdon.options[ddlHinhthucdon.selectedIndex].value;
            if (val == 3 || val == 10) {//Đơn + Công văn và KNTP + Công Văn

                var chkIsTrongNganh = document.getElementById('<%=chkIsTrongNganh.ClientID%>');
                if (chkIsTrongNganh.checked) {

                } else {
                    var txtCV_DonViGuiNgoaiNganh = document.getElementById('<%=txtCV_DonViGuiNgoaiNganh.ClientID%>');
                    if (txtCV_DonViGuiNgoaiNganh.value.trim() == "") {
                        alert('Bạn chưa nhập đơn vị gửi công văn. Hãy nhập lại!');
                        txtCV_DonViGuiNgoaiNganh.Focus();
                        return false;
                    }
                }
                var txtCV_So = document.getElementById('<%=txtCV_So.ClientID%>');
                var LengthSoCV = txtCV_So.value.trim().length;
                if (LengthSoCV == 0) {
                    alert('Bạn chưa nhập số công văn. Hãy nhập lại!');
                    txtCV_So.Focus();
                    return false;
                }
                if (LengthSoCV > 50) {
                    alert('Số công văn không quá 50 ký tự. Hãy nhập lại!');
                    txtCV_So.Focus();
                    return false;
                }
                var txtCV_Ngay = document.getElementById('<%=txtCV_Ngay.ClientID%>');
                var LengthNgayCV = txtCV_Ngay.value.trim().length;
                if (LengthNgayCV == 0) {
                    alert('Bạn phải nhập ngày công văn theo định dạng (dd/MM/yyyy). Hãy nhập lại!');
                    txtCV_Ngay.focus();
                    return false;
                }
                if (LengthNgayCV > 0) {
                    var arr = txtCV_Ngay.value.split('/');
                    var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                    if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                        alert('Bạn phải nhập ngày công văn theo định dạng (dd/MM/yyyy). Hãy nhập lại!');
                        txtCV_Ngay.focus();
                        return false;
                    }
                }
            }

            return true;
        }
    </script>
</asp:Content>
