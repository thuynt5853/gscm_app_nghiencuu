<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pVuAn.aspx.cs"
    Inherits="WEB.GSTP.QLAN.GDTTT.Giaiquyet.Popup.pVuAn" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cập nhật thông tin vụ án</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />

    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../UI/js/Common.js"></script>

    <script src="../../../../UI/js/chosen.jquery.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hddLoaiDon" runat="server" Value="1" />
        <asp:HiddenField ID="hddIsAnPT" runat="server" Value="PT" />
        <style>
            body {
                width: 100%;
                min-height: 500px;
                min-width: 500px;
                overflow-y: auto;
                overflow-x: auto;
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
                }
        </style>

        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            
            <ContentTemplate>
                <div class="box">
                    <div class="box_nd">
                        <div class="truong">
                            <div style="margin: 5px; text-align: center; width: 95%">
                                <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                                <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
                            </div>
                            <div style="margin: 5px; width: 95%; color: red;">
                                <asp:Label ID="lttMsgT" runat="server"></asp:Label>
                            </div>
                            <div class="boxchung">
                                                                 
                                <h4 class="tleboxchung">1. Thông tin thụ lý</h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="tableva">
                                        
                                        <asp:Panel ID="pnThuLY" runat="server" Visible ="false">
                                            <tr>
                                                <td style="width: 120px;">Số thụ lý<span class="batbuoc">*</span></td>
                                                <td style="width: 255px;">
                                                    <asp:TextBox ID="txtSoThuLy" CssClass="user" runat="server"
                                                        Width="242px"></asp:TextBox>
                                                </td>
                                                <td style="width: 95px;">Ngày thụ lý<span class="batbuoc">*</span></td>
                                                <td>
                                                    <asp:TextBox ID="txtNgayThuLy" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayThuLy" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayThuLy" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                                </td>
                                            </tr>
                                         </asp:Panel>
                                        <tr>
                                            <td>Người đề nghị</td>
                                            <td>
                                                <asp:TextBox ID="txtNguoiDeNghi" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            </td>
                                            <td>Địa chỉ</td>
                                            <td>
                                                <asp:TextBox ID="txtNguoiDeNghi_DiaChi" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Ngày ghi trên đơn/Ngày gửi đơn</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayTrongDon" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayTrongDon" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayTrongDon" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                            <td>Ngày nhận đơn</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayNhanDon" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayNhanDon" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayNhanDon" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                        </tr>

                                        <!---------------------------->
                                        <asp:Panel ID="pnHoSoVKS" runat="server" Visible="false">
                                            <tr>
                                                <td style="width: 110px;">VKS Kháng nghị Số<span class="batbuoc">*</span></td>
                                                <td style="width: 255px;">
                                                    <asp:TextBox ID="txtVKS_So" CssClass="user" runat="server"
                                                      Width="242px"></asp:TextBox>
                                                </td>
                                                <td style="width: 110px;">Ngày Kháng nghị<span class="batbuoc">*</span></td>
                                                <td>
                                                    <asp:TextBox ID="txtVKS_Ngay" CssClass="user" runat="server" Width="110px" AutoPostBack="true" ></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender12" runat="server" TargetControlID="txtVKS_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender12" runat="server" TargetControlID="txtVKS_Ngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Đơn vị Kháng nghị<span class="batbuoc">*</span></td>
                                                <td colspan="3">
                                                    <asp:DropDownList ID="dropVKS_NguoiKy" CssClass="chosen-select"
                                                        runat="server" Width="498px">
                                                    </asp:DropDownList>
                                            </tr>
                                        </asp:Panel>
                                            <!----------------------------> 
                                        
                                    </table>
                                </div>

                                <!---------------------------->
                                <div style="float: left; margin-top: 8px; width: 100%;">
                                    <h4 class="tleboxchung">2. Thông tin BA/QĐ đề nghị GĐT,TT</h4>
                                    <div class="boder" style="padding: 10px;">
                                        <table class="tableva">
                                             <tr>
                                    <td style="width: 120px;">Loại bản án</td>
                                    <td style="width: 255px;">
                                       <asp:DropDownList ID="ddlLoaiBA" CssClass="chosen-select"
                                            AutoPostBack="true" OnSelectedIndexChanged="ddlLoaiBA_SelectedIndexChanged"
                                            runat="server" Width="250px">
                                           <asp:ListItem Value="3" Text="Phúc thẩm" Selected ="True"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Sơ thẩm"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="QĐ GĐT"></asp:ListItem>
                                        </asp:DropDownList>

                                    </td>
                                    <td style="width: 95px;">Loại án</td>
                                    <td>
                                       <asp:DropDownList ID="dropLoaiAn" runat="server"
                                            Width="250px" CssClass="chosen-select"
                                            AutoPostBack="true" OnSelectedIndexChanged="dropLoaiAn_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </td>
                                </tr>

                                             <!---------------QĐ GDT----------------------------->
                                <asp:Panel ID="pnQDGDT" runat="server" Visible ="false">
                                    <tr>
                                        <td style="width: 120px;">Số QĐ GĐT
                                    <asp:Literal ID="ltt_SoGDT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal>
                                        </td>
                                        <td style="width: 255px;">
                                            <asp:TextBox ID="txtSoQĐGDT" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>

                                        <td style="width: 95px;">Ngày QĐ GĐT<asp:Literal ID="ltt_NgayGDT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal></td>
                                        <td>
                                            <asp:TextBox ID="txtNgayGDT" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender15" runat="server" TargetControlID="txtNgayGDT" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender15" runat="server" TargetControlID="txtNgayGDT"
                                                Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Tòa án ra QĐ GDT<asp:Literal ID="ltt_ToaGDT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal></td>
                                        <td>
                                            <asp:DropDownList ID="dropToaGDT" CssClass="chosen-select"
                                                AutoPostBack="true" OnSelectedIndexChanged="dropToaGDT_SelectedIndexChanged"
                                                runat="server" Width="250px">
                                            </asp:DropDownList>
                                        </td>
                                        <td colspan="2"></td>
                                    </tr>
                                    <tr><td colspan="4" style="border-bottom: 1.5px dotted #808080;"></td></tr>
                                </asp:Panel>
                                <!---------------An PT----------------------------->
                                <asp:Panel ID="pnPhucTham" runat="server">
                                            <tr>
                                                <td style="width: 120px;">Số BA/QĐ Phúc thẩm
                                                    <asp:Literal ID="lttBB_SoPT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal></td>
                                                <td style="width: 255px;">
                                                    <asp:TextBox ID="txtSoBA" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>
                                                <td style="width: 95px;">Ngày BA/QĐ Phúc thẩm
                                                    <asp:Literal ID="lttBB_NgayPT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtNgayBA" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayBA" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgayBA"
                                                        Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Tòa án xét xử PT
                                                    <asp:Literal ID="lttBB_ToaPT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="dropToaAn" CssClass="chosen-select"
                                                        AutoPostBack="true" OnSelectedIndexChanged="dropToaAn_SelectedIndexChanged"
                                                        runat="server" Width="250px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td></td>
                                                <td>
                                                  
                                                </td>
                                            </tr>

                                      </asp:Panel>
                                            <!-----------An ST--------------------------------->
                                            <asp:Panel ID="pnAnST" runat="server" >

                                                <tr>
                                                    <td>Số BA/QĐ Sơ thẩm
                                                        <asp:Literal ID="lttBB_SoST" runat="server" Visible="false" Text="<span class='batbuoc'>*</span>"></asp:Literal>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtSoBA_ST" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>
                                                    <td>Ngày BA/QĐ Sơ thẩm
                                                        <asp:Literal ID="lttBB_NgayST" runat="server" Visible="false" Text="<span class='batbuoc'>*</span>"></asp:Literal>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtNgayBA_ST" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txtNgayBA_ST" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txtNgayBA_ST"
                                                            Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>Tòa án xét xử sơ thẩm
                                                        <asp:Literal ID="lttBB_ToaST" runat="server" Visible="false" Text="<span class='batbuoc'>*</span>"></asp:Literal>
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList ID="dropToaAnST" CssClass="chosen-select"
                                                            runat="server" Width="250px">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td></td>
                                                    <td></td>
                                                </tr>
                                            </asp:Panel>

                                            <tr>
                                                <td>Quan hệ pháp luật<span class="batbuoc">*</span></td>
                                                <td>
                                                 <span  style="display:none">
                                                     <asp:DropDownList ID="dropQHPL"
                                                        CssClass="chosen-select" runat="server" Width="250">
                                                    </asp:DropDownList>
                                                 </span>
                                                    <asp:TextBox ID="txtQHPL_TEXT" Width="96%" CssClass="user" TextMode="multiline" Rows="3"
                                                                        placeholder="Quan hệ pháp luật"
                                                                        runat="server" Text='<%#Eval("QHPL_TEXT") %>'></asp:TextBox>


                                                </td>
                                                <td style="display: none;">Quan hệ PL tranh chấp</td>
                                                <td style="display: none;">
                                                    <asp:DropDownList ID="dropQHPLThongKe"
                                                        CssClass="chosen-select" runat="server" Width="250px">
                                                        <asp:ListItem Value="0" Text="Chọn"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" style="height: 10px;"></td>
                                            </tr>
                                            <!----------------------------->
                                            <asp:Panel ID="pnNguyenDon" runat="server">
                                                <tr>
                                                    <td colspan="4" style="height: 5px;"></td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4"><b style="margin-right: 10px;">Nguyên đơn/ Người khởi kiện </b>
                                                       <asp:HiddenField ID="hddSoND" runat="server" />
                                                        <asp:LinkButton ID="lkThemND" runat="server" CssClass="buttonpopup them_user clear_bottom" ToolTip="Thêm Nguyên đơn/ Người khởi kiện"
                                                            OnClientClick="return validate();" OnClick="lkThemND_Click">&nbsp;</asp:LinkButton>
                                                        <asp:CheckBox ID="chkND" runat="server" Text="Có địa chỉ"
                                                            AutoPostBack="true" OnCheckedChanged="chkND_CheckedChanged" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4" style="vertical-align: top;">
                                                        <asp:Repeater ID="rptNguyenDon" runat="server" OnItemCommand="rptNguyenDon_ItemCommand" OnItemDataBound="rptDuongSu_ItemDataBound">
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

                                                                    <asp:Panel ID="pn" runat="server">
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
                                                         <asp:HiddenField ID="hddSoBD" runat="server" />
                                                        <asp:LinkButton ID="lkThemBD" runat="server" CssClass="buttonpopup them_user clear_bottom" ToolTip="Thêm bị đơn/ Người bị kiện"
                                                            OnClientClick="return validate();" OnClick="lkThemBD_Click">&nbsp;</asp:LinkButton>
                                                        <asp:CheckBox ID="chkBD" runat="server" Text="Có địa chỉ"
                                                            AutoPostBack="true" OnCheckedChanged="chkBD_CheckedChanged" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4" style="vertical-align: top;">

                                                        <asp:Repeater ID="rptBiDon" runat="server"
                                                            OnItemCommand="rptBiDon_ItemCommand" OnItemDataBound="rptDuongSu_ItemDataBound">
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
                                                                    <asp:Panel ID="pn" runat="server">
                                                                        <td width="250px">
                                                                            <asp:HiddenField ID="hddHuyenID" runat="server" Value='<%# Eval("HUYENID") %>' />
                                                                            <asp:DropDownList ID="ddlTinhHuyen" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                                        </td>
                                                                        <td width="190px">
                                                                            <asp:TextBox ID="txtDiachi" Width="96%"
                                                                                placeholder="Địa chỉ chi tiết" CssClass="user" runat="server" Text='<%# Eval("DiaChi") %>'></asp:TextBox></td>
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
                                                      <asp:HiddenField ID="hddSoDSKhac" runat="server" />
                                                        <asp:LinkButton ID="lkThemDSKhac" runat="server" CssClass="buttonpopup them_user clear_bottom" ToolTip="Thêm Người có QL&NVLQ"
                                                            OnClientClick="return validate();" OnClick="lkThemDSKhac_Click">&nbsp;</asp:LinkButton>
                                                        <asp:CheckBox ID="chkDSKhac" runat="server" Text="Có địa chỉ"
                                                            AutoPostBack="true" OnCheckedChanged="chkDSKhac_CheckedChanged" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4">
                                                        <asp:Repeater ID="rptDsKhac" runat="server"
                                                            OnItemCommand="rptDsKhac_ItemCommand" OnItemDataBound="rptDuongSu_ItemDataBound">
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
                                                                    <asp:Panel ID="pn" runat="server">
                                                                        <td width="250px">
                                                                            <asp:HiddenField ID="hddHuyenID" runat="server" Value='<%# Eval("HUYENID") %>' />
                                                                            <asp:DropDownList ID="ddlTinhHuyen" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                                        </td>
                                                                        <td style="width: 190px">
                                                                            <asp:TextBox ID="txtDiachi"
                                                                                placeholder="Địa chỉ chi tiết" Width="96%" CssClass="user" runat="server" Text='<%# Eval("DiaChi") %>'></asp:TextBox></td>
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
                                    </div>
                                </div>
                                <!---------------------------->
                                <div style="float: left; margin-top: 8px; width: 100%;">
                                    <h4 class="tleboxchung">3. Thẩm tra viên/ Lãnh đạo   
                                <asp:LinkButton ID="lkTTV" runat="server" Text="[ Mở ]" ForeColor="#0E7EEE" OnClick="lkTTV_Click"></asp:LinkButton>
                                    </h4>
                                    <div class="boder" style="padding: 10px;">
                                        <asp:Panel ID="pnTTV" runat="server" Visible="false">
                                            <table class="tableva">
                                                <tr>
                                                    <td style="width: 120px;">Ngày phân công</td>
                                                    <td style="width: 255px;">
                                                        <asp:TextBox ID="txtNgayphancong" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtNgayphancong" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtNgayphancong" Mask="99/99/9999"
                                                            MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    </td>
                                                    <td style="width: 95px;">Thẩm tra viên</td>
                                                    <td>
                                                        <asp:DropDownList ID="dropTTV"
                                                            AutoPostBack=" true" OnSelectedIndexChanged="dropTTV_SelectedIndexChanged"
                                                            CssClass="chosen-select" runat="server" Width="250">
                                                        </asp:DropDownList></td>
                                                </tr>
                                                <tr>
                                                    <td>Ngày TTV nhận đơn đề nghị và các tài liệu kèm theo</td>
                                                    <td>
                                                        <asp:TextBox ID="txtNgayNhanTieuHS" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayNhanTieuHS" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayNhanTieuHS" Mask="99/99/9999"
                                                            MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    </td>
                                                    <td>Ngày TTV nhận hồ sơ </td>
                                                    <td>
                                                        <asp:TextBox ID="txtNgayNhanHS" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtNgayNhanHS" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtNgayNhanHS" Mask="99/99/9999"
                                                            MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td></td>
                                                    <td></td>
                                                    <td colspan="2"><i>(Lưu ý: hệ thống sẽ tự động tạo phiếu nhận tương ứng nếu mục 'Ngày TTV nhận hồ sơ' được chọn)</i></td>
                                                </tr>
                                                <tr>
                                                    <td>Ngày Vụ GĐ nhận hồ sơ</td>
                                                    <td>
                                                        <asp:TextBox ID="txtNgayGDNhanHS" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayGDNhanHS" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayGDNhanHS" Mask="99/99/9999"
                                                            MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    </td>
                                                    <td colspan="2"></td>
                                                </tr>
                                                <tr>
                                                    <td>Ngày phân công LĐ</td>
                                                    <td>
                                                        <asp:TextBox ID="txtNgayPhanCong_LDV" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender10" runat="server" TargetControlID="txtNgayPhanCong_LDV" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender10" runat="server" TargetControlID="txtNgayPhanCong_LDV" Mask="99/99/9999"
                                                            MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    </td>
                                                    <td>Lãnh đạo Vụ</td>
                                                    <td>
                                                        <asp:DropDownList ID="dropLanhDao"
                                                            CssClass="chosen-select" runat="server" Width="250">
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>Ngày phân công TP</td>
                                                    <td>
                                                        <asp:TextBox ID="txtNgayPhanCong_TP" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender11" runat="server" TargetControlID="txtNgayPhanCong_TP" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender11" runat="server" TargetControlID="txtNgayPhanCong_TP" Mask="99/99/9999"
                                                            MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    </td>
                                                    <td>Thẩm phán</td>
                                                    <td>
                                                        <asp:DropDownList ID="dropThamPhan"
                                                            CssClass="chosen-select" runat="server" Width="250">
                                                        </asp:DropDownList></td>
                                                </tr>

                                                <tr>
                                                    <td>Ghi chú</td>
                                                    <td colspan="3">
                                                        <asp:TextBox ID="txtGhiChu" CssClass="user"
                                                            runat="server" Width="605px"></asp:TextBox>
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </div>
                                </div>
                                <!---------------------------->
                            </div>
                            <div style="margin: 5px; text-align: center; width: 95%">
                                <asp:Button ID="cmdUpdate2" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                                <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
                            </div>
                            <div style="margin: 5px; width: 95%; color: red;">
                                <asp:Label ID="lttMsg" runat="server"></asp:Label>
                                 <asp:HiddenField ID="hddDonID" runat="server" Value="0" />
        <asp:HiddenField ID="hddVuAnID" runat="server" Value="0" />
        <asp:HiddenField ID="hddThuLyLaiVuAnID" runat="server" Value="0" />
        <asp:HiddenField ID="hddGUID" runat="server" Value="" />
        <asp:HiddenField ID="hddNext" runat="server" Value="0" />
        <asp:HiddenField ID="hddInputAnST" runat="server" Value="0" />
                            </div>
                        </div>
                    </div>
                </div>
                <script>
                    function ReloadParent() {
                        window.onunload = function (e) {
                            opener.LoadDsDon();
                        };
                        window.close();
                    }

                    function validate() {
                        if (!validate_thuly())
                            return false;
                        if (!validate_banan_qd())
                            return false;
                        //--loai an
                        var dropLoaiAn = document.getElementById('<%=dropLoaiAn.ClientID%>');
                        var value_Loaian = dropLoaiAn.options[dropLoaiAn.selectedIndex].value;
                        if (value_Loaian == "0") {
                            alert("Bạn chưa chọn Loại án. Hãy kiểm tra lại!");
                            dropLoaiAn.focus();
                            return false;
                        }
                        //--quan he phap luat
                        <%--var dropQHPL = document.getElementById('<%=dropQHPL.ClientID%>');
                        var value_QHPL = dropQHPL.options[dropQHPL.selectedIndex].value;
                        if (value_QHPL == "0" || value_QHPL == null) {
                            alert("Bạn chưa chọn Quan hệ pháp luật. Hãy kiểm tra lại!");
                            dropQHPL.focus();
                            return false;
                        }--%>
                        var txtQHPL_TEXT = document.getElementById('<%=txtQHPL_TEXT.ClientID%>');
                        if (!Common_CheckTextBox(txtQHPL_TEXT, 'Quan hệ pháp luật'))
                            return false;
                        

                        return true;
                    }
                    function validate_thuly() {
                        var value_change = "";
                        var hddLoaiDon = document.getElementById('<%=hddLoaiDon.ClientID%>');
                        if (hddLoaiDon.value != "4") {
                            var txtSoThuLy = document.getElementById('<%=txtSoThuLy.ClientID%>');
                            if (!Common_CheckTextBox(txtSoThuLy, 'Số thụ lý'))
                                return false;
                            //-----------------------------
                            var txtNgayThuLy = document.getElementById('<%=txtNgayThuLy.ClientID%>');
                            if (!CheckDateTimeControl(txtNgayThuLy, "Ngày thụ lý"))
                                return false;
                        }
                        else
                        {
                            var txtVKS_So = document.getElementById('<%=txtVKS_So.ClientID%>');
                            if (!Common_CheckTextBox(txtVKS_So, 'Số Kháng nghị VKS'))
                                return false;
                            //-----------------------------
                            var txtVKS_Ngay = document.getElementById('<%=txtVKS_Ngay.ClientID%>');
                            if (!CheckDateTimeControl(txtVKS_Ngay, "Ngày Kháng nghị VKS"))
                                return false; 

                            var dropVKS_NguoiKy = document.getElementById('<%=dropVKS_NguoiKy.ClientID%>');
                            value_change = dropVKS_NguoiKy.options[dropVKS_NguoiKy.selectedIndex].value;
                            if (value_change == "0") {
                                alert("Bạn chưa chọn Người ký quyết định Kháng Nghị. Hãy kiểm tra lại!");
                                dropVKS_NguoiKy.focus();
                                return false;
                            }
                        }

                        //-----------------------------
                        return true;
                    }
                    function validate_banan_qd() {
                            var value_change = "";
                            //-----------------------------ddlLoaiBA
                            var hddIsAnPT = document.getElementById('<%=hddIsAnPT.ClientID%>');
                            if (hddIsAnPT.value == "GDT") {
                                var txtSoQĐGDT = document.getElementById('<%=txtSoQĐGDT.ClientID%>');
                                if (!Common_CheckTextBox(txtSoQĐGDT, 'Số QĐ Giám đốc thẩm'))
                                    return false;
                                var txtNgayGDT = document.getElementById('<%=txtNgayGDT.ClientID%>');
                                if (!CheckDateTimeControl(txtNgayGDT, "Ngày QĐ Giám đốc thẩm"))
                                    return false;
                                //-----------------------------
                                var dropToaGDT = document.getElementById('<%=dropToaGDT.ClientID%>');
                                value_change = dropToaGDT.options[dropToaGDT.selectedIndex].value;
                                if (value_change == "0") {
                                    alert("Bạn chưa chọn Tòa án ra Quyết định Giám đốc thẩm. Hãy kiểm tra lại!");
                                    dropToaGDT.focus();
                                    return false;
                                }
                            }
                            else if (hddIsAnPT.value == "PT") {
                                var txtSoBA = document.getElementById('<%=txtSoBA.ClientID%>');
                                if (!Common_CheckTextBox(txtSoBA, 'Số BA/QĐ phúc thẩm'))
                                    return false;
                                var txtNgayBA = document.getElementById('<%=txtNgayBA.ClientID%>');
                                if (!CheckDateTimeControl(txtNgayBA, "Ngày BA/QĐ phúc thẩm"))
                                    return false;
                                //-----------------------------
                                var dropToaAn = document.getElementById('<%=dropToaAn.ClientID%>');
                                value_change = dropToaAn.options[dropToaAn.selectedIndex].value;
                                if (value_change == "0") {
                                    alert("Bạn chưa chọn Tòa án thụ lý vụ việc phúc thẩm. Hãy kiểm tra lại!");
                                    dropToaAn.focus();
                                    return false;
                                }
                            }
                            else if (hddIsAnPT.value == "ST") {
                                var txtSoBA_ST = document.getElementById('<%=txtSoBA_ST.ClientID%>');
                                if (!Common_CheckTextBox(txtSoBA_ST, 'Số BA/QĐ sơ thẩm'))
                                    return false;
                                var txtNgayBA_ST = document.getElementById('<%=txtNgayBA_ST.ClientID%>');
                                if (!CheckDateTimeControl(txtNgayBA_ST, "Ngày BA/QĐ sơ thẩm"))
                                    return false;
                                //-----------------------------
                                var dropToaAnST = document.getElementById('<%=dropToaAnST.ClientID%>');
                                value_change = dropToaAnST.options[dropToaAnST.selectedIndex].value;
                                if (value_change == "0") {
                                    alert("Bạn chưa chọn Tòa án thụ lý vụ việc  sơ thẩm. Hãy kiểm tra lại!");
                                    dropToaAnST.focus();
                                    return false;
                                }
                            }
                            //-----------------------------
                            return true;
                        }
                </script>
                <script type="text/javascript">

                    function pageLoad(sender, args) {
                        var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                        for (var selector in config) { $(selector).chosen(config[selector]); }
                    }
                </script>

            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                <div class="processmodal">
                    <div class="processcenter">
                        <img src="/UI/img/process.gif" />
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
    </form>
</body>
</html>
