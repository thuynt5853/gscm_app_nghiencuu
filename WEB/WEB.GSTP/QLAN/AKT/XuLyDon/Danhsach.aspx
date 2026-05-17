<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.QLAN.AKT.XuLyDon.Danhsach" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/QLAN/DONGHEP/Thongtindonghep.ascx" TagPrefix="uc2" TagName="DONGHEP" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .auto-style1 {
            height: 36px;
        }

        .auto-style2 {
            height: 36px;
        }

        .lable_td {
            width: 117px;
        }

        .checkbox {
            width: 100%;
        }

            .checkbox label {
                margin-left: 5px;
            }
		 .TenFile_css {
            color: inherit;
        }

        .text_Right_css {
            text-align: right;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddFileid" Value="0" runat="server" />
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddTotalPageAP" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndexAP" Value="1" runat="server" />
    <asp:HiddenField ID="hddNgayNhanDon" Value="" runat="server" />
    <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
    <asp:HiddenField ID="hddShowCommandAP" runat="server" Value="True" />
    <div id="divBackground" style="position: absolute; top: 0px; left: 0px; background-color: black; z-index: 100; opacity: 0.8; filter: alpha(opacity=60); -moz-opacity: 0.8; overflow: hidden; display: none">
    </div>
    <div class="box">

        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Giải quyết đơn</h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        <tr>
                                            <td class="lable_td">Tên đương sự</td>
                                            <td colspan="3">
                                                <asp:TextBox ID="txtDuongSu" CssClass="user" runat="server" Width="242px" MaxLength="50" Enabled="false"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="lable_td">Biện pháp GQ/YC</td>
                                            <td style="width: 260px;">
                                                <asp:DropDownList ID="dropBienPhapGQ" CssClass="chosen-select" runat="server"
                                                    Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlBienPhapGQ_SelectedIndexChanged">
                                                </asp:DropDownList>
                                            </td>
                                            <td class="lable_td">
                                                <asp:Label ID="lblNgayGQ" runat="server" Text="Ngày GQ/YC"></asp:Label><span class="must_input">(*)</span></td>
                                            <td>
                                                <asp:TextBox ID="txtNgayGQ" runat="server" CssClass="user" Width="145px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="txtNgayGQ_CalendarExtender" runat="server" TargetControlID="txtNgayGQ" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayGQ" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                        </tr>
                                        <!---------chọn = chuyen don trong nganh-------->
                                        <asp:Panel ID="pnCDTN" runat="server" Visible="false">
                                            <tr>
                                                <td>Tòa án nhận<span class="must_input">(*)</span></td>
                                                <td colspan="3">
                                                    <asp:HiddenField ID="hddToaAn" runat="server" Value="0" />
                                                    <a alt="Nhập tên để chọn tòa án" class="tooltipbottom">
                                                        <asp:TextBox ID="txtToaAn" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                    </a>
                                                </td>

                                            </tr>
                                        </asp:Panel>
                                        <!-----------------Chuyen don ngoai nganh-------------------------->
                                        <asp:Panel ID="pnCDNN" runat="server" Visible="false">
                                            <tr>
                                                <td>CQ/TC nhận đơn<span class="must_input">(*)</span></td>
                                                <td colspan="3">
                                                    <asp:TextBox ID="txtCDNN_TenCoQuan" CssClass="user" runat="server" Width="242px" MaxLength="50"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td>Ngày chuyển</td>
                                                <td colspan="3">
                                                    <asp:TextBox ID="txtCDNN_NgayChuyen" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="txtCDTN_NgayNhan_CalendarExten" runat="server" TargetControlID="txtCDNN_NgayChuyen" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtCDNN_NgayChuyen" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </tr>
                                        </asp:Panel>
                                        <!-----------------Tra don -------------------------->
                                        <asp:Panel ID="pnTraDon" runat="server" Visible="false">
                                            <tr>
                                                <td>Lý do<span class="must_input">(*)</span></td>
                                                <td>
                                                    <asp:DropDownList ID="ddlLyTradon" runat="server" CssClass="chosen-select" Width="250px"></asp:DropDownList>
                                                </td>
                                                <td class="lable_td">Ngày trả đơn</td>
                                                <td>
                                                    <asp:TextBox ID="txtTradon_Ngay" runat="server" CssClass="user" Width="145px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtTradon_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtTradon_Ngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>

                                            </tr>
                                        </asp:Panel>
                                        <!---------------------------------------------->
                                        <asp:Panel ID="pnYCBS" runat="server" Visible="false">
                                            <tr>
                                                <%--<td>Ngày yêu cầu</td>
                                                <td >
                                                    <asp:TextBox ID="txtNgayYCBS" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayYCBS" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayYCBS" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender4" ControlToValidate="txtNgayYCBS" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                </td>--%>
                                                <td>Thời hạn (ngày)</td>
                                                <td colspan="3">
                                                    <asp:TextBox ID="txtThoihanBSYC" runat="server" CssClass="user text_Right_css" Width="242px" MaxLength="2" onkeypress="return isNumber(event)"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td>Yêu cầu bổ sung</td>
                                                <td colspan="3">
                                                    <asp:TextBox ID="txtYCBS" CssClass="user" runat="server" Width="535px" TextMode="MultiLine" Rows="2"></asp:TextBox></td>
                                            </tr>
                                        </asp:Panel>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblLydo" runat="server" Text="Lý do"></asp:Label></td>
                                            <td colspan="3">
                                                <asp:TextBox ID="txtLyDo" CssClass="user" runat="server" Width="535px" TextMode="MultiLine" Rows="2"></asp:TextBox></td>
                                        </tr>
                                        <asp:Panel ID="pnThongbao" runat="server" Visible="false">
                                            <tr>
                                                <td>Ngày thông báo<span class="batbuoc">(*)</span></td>
                                                <td>
                                                    <asp:TextBox ID="txtNgaythongbao" runat="server" CssClass="user" Width="242px" MaxLength="10"
                                                        AutoPostBack="true" OnTextChanged="txtNgaythongbao_TextChanged"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgaythongbao" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgaythongbao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                                <td class="lable_td">Số thông báo<span class="must_input">(*)</span></td>
                                                <td colspan="3">
                                                    <asp:TextBox ID="txtSothongbao" runat="server" CssClass="user" Width="90px"></asp:TextBox>
                                                    <asp:DropDownList ID="ddlStbPhu" CssClass="user" runat="server" Width="54px">
                                                        <asp:ListItem Value="" Text="" Selected="True"></asp:ListItem>
                                                        <asp:ListItem Value="A" Text="A"></asp:ListItem>
                                                        <asp:ListItem Value="B" Text="B"></asp:ListItem>
                                                        <asp:ListItem Value="C" Text="C"></asp:ListItem>
                                                        <asp:ListItem Value="D" Text="D"></asp:ListItem>
                                                        <asp:ListItem Value="E" Text="E"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                        </asp:Panel>
                                        <tr>
                                            <td colspan="4">
                                                <div style="text-align: center;">

                                                    <asp:Button ID="cmdCapNhat" runat="server"
                                                        CssClass="buttoninput" Text="Lưu" OnClick="cmdCapNhat_Click" OnClientClick=" return Validate();" />
                                                    <button class="buttoninput" onclick="popup_in()" id="btnin" runat="server" visible="false">In</button>
                                                    <asp:Button ID="cmdLoad" runat="server" Style="display: none;" disable="false"
                                                        OnClick="cmdLoad_Click" />
                                                </div>
                                                <script type="text/javascript">
                                                    function popup_in() {
                                                        var dropBienPhapGQ = $("#<%= dropBienPhapGQ.ClientID %>").val();
                                                        var hddCurrID = $("#<%= hddCurrID.ClientID %>").val();
                                                        var link = "/BaoCao/ADS/BM25/ViewReport.aspx?ctype=" + dropBienPhapGQ + "&cdon=<%=sDONID%>" + "&cid=" + hddCurrID;
                                                        var width = 660;
                                                        var height = 700;
                                                        PopupReport(link, "báo cáo", width, height);
                                                    }
                                                    function PopupReport(pageURL, title, w, h) {
                                                        var left = (screen.width / 2) - (w / 2);
                                                        var top = (screen.height / 2) - (h / 2);
                                                        //OpenPopUpPage(pageURL, null, w, h);
                                                        var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,scrollbars=yes,resizable=yes,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
                                                        return targetWin;
                                                    }
                                                </script>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <asp:HiddenField ID="hddCurrID" runat="server" />
                                                <asp:HiddenField ID="hddChiTietID" runat="server" />
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
                                                    </div>
                                                </div>
                                                <div>
                                                    <asp:DataGrid ID="rpt" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                        PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                                        CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                                        ItemStyle-CssClass="chan" Width="100%"
                                                        OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                                <HeaderTemplate>
                                                                    TT
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <%# Container.DataSetIndex + 1 %>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderStyle-Width="350px" HeaderStyle-HorizontalAlign="Center">
                                                                <HeaderTemplate>
                                                                    Nguyên đơn/ Người KK
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <%#Eval("DUONGSU") %>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                                                <HeaderTemplate>
                                                                    Nội dung
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <%#Eval("NOIDUNG") %>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderStyle-Width="160px" HeaderStyle-HorizontalAlign="Center">
                                                                <HeaderTemplate>
                                                                    Biện pháp GQ
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <%#Eval("BIENPHAPGQ") %>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center">
                                                                <HeaderTemplate>
                                                                    Người GQ
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <%#Eval("NGUOIGQ") %>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                                <HeaderTemplate>
                                                                    Ngày GQ/YC
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYGQ_YC")) %>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>

                                                            <%--<asp:TemplateColumn HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                                <HeaderTemplate>
                                                                    Nơi tiếp nhận
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Literal ID="lttNoiTiepNhan" runat="server"></asp:Literal>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>--%>
                                                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                                                <HeaderTemplate>File VB thông báo</HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:ImageButton ID="lblDownload" ImageUrl="~/UI/img/ghim.png" runat="server" CausesValidation="false" CommandName="Download"
                                                                        CommandArgument='<%#Eval("FILEID") %>' ToolTip='<%#Eval("TENFILE")%>' />
                                                                    <%--<asp:LinkButton ID="lblDownload" runat="server" Text='<%#Eval("TENFILE") %>'  CssClass="TenFile_css"></asp:LinkButton>--%>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderStyle-Width="180px" HeaderStyle-HorizontalAlign="Center">
                                                                <HeaderTemplate>
                                                                    Người tạo
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    - Người tạo: <%# Eval("NguoiTao") %>
                                                                    <br />
                                                                    - Ngày tạo: <%# string.Format("{0:dd/MM/yyyy}",Eval("NgayTao")) %>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <%--<asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                                        <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lblDownload" runat="server" Text='<%#Eval("TENFILE") %>' CausesValidation="false" CommandName="Download"
                                                                CommandArgument='<%#Eval("FILEID") %>' CssClass="TenFile_css"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>--%>

                                                            <asp:TemplateColumn HeaderStyle-Width="105px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">

                                                                <HeaderTemplate>
                                                                    Thao tác
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <%--<asp:LinkButton ID="lblDownload" runat="server" Text="Tải về" CausesValidation="false" CommandName="Download" ForeColor="#0e7eee"
                                                                        CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                                    &nbsp;&nbsp;--%>
                                                                    <asp:LinkButton ID="lblThem" runat="server" Text="Xử lý đơn" CausesValidation="false" CommandName="Them" ForeColor="#0e7eee"
                                                                        CommandArgument='<%# Eval("DONID") + "," + Eval("DON_CHITIETID") %>'></asp:LinkButton>
                                                                    <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                                        CommandArgument='<%# Eval("ID") + "," + Eval("DONID") + "," + Eval("DON_CHITIETID") %>'></asp:LinkButton>
                                                                    &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee" CommandName="Xoa"
                                                                        CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                                    <br />
                                                                    <%-- <asp:LinkButton ID="lbtBoSung" runat="server" CausesValidation="false" Text="Bổ sung tài liệu" ForeColor="#0e7eee" CommandName="BoSung" --%>
                                                                    <%--     CommandArgument='<%#Eval("ID") %>' ToolTip="Bổ sung tài liệu" Visible="false"></asp:LinkButton> --%>
                                                                    <asp:LinkButton ID="lbtBoSung" runat="server" CausesValidation="false" Text="Lịch sử xử lý" ForeColor="#0e7eee" CommandName="BoSung"
                                                                        CommandArgument='<%#Eval("ID") %>' ToolTip="Lịch sử xử lý" Visible="false"></asp:LinkButton>
                                                                    <br/>
                                                                    <asp:LinkButton ID="lbtTraLaiDon" runat="server" CausesValidation="false" Text="Trả lại đơn" ForeColor="#0e7eee" CommandName="TraLaiDon"
                                                                        CommandArgument='<%#Eval("ID") %>' ToolTip="Trả lại đơn" Visible="false"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="TOA_GIAIQUYET_ID" Visible="false"></asp:BoundColumn>
                                                        </Columns>
                                                        <HeaderStyle CssClass="header"></HeaderStyle>
                                                        <ItemStyle CssClass="chan"></ItemStyle>
                                                        <PagerStyle Visible="false"></PagerStyle>
                                                    </asp:DataGrid>
                                                    <%--<asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                                                        <HeaderTemplate>
                                                            <table class="table2" width="100%" border="1">
                                                                <tr class="header">
                                                                    <td width="42px">
                                                                        <div align="center"><strong>TT</strong></div>
                                                                    </td>
                                                                    <td>
                                                                        <div align="center"><strong>Biện pháp GQ</strong></div>
                                                                    </td>
                                                                    <td width="10%">
                                                                        <div align="center"><strong>Ngày GQ/YC</strong></div>
                                                                    </td>
                                                                    <td width="30%">
                                                                        <div align="center"><strong>Nơi tiếp nhận</strong></div>
                                                                    </td>
                                                                    <td width="10%">
                                                                        <div align="center"><strong>File đính kèm</strong></div>
                                                                    </td>
                                                                    <td width="10%">
                                                                        <div align="center"><strong>Nguời tạo</strong></div>
                                                                    </td>
                                                                    <td width="10%">
                                                                        <div align="center"><strong>Ngày tạo</strong></div>
                                                                    </td>
                                                                    <td width="120px">
                                                                        <div align="center"><strong>Thao tác</strong></div>
                                                                    </td>
                                                                </tr>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td><%# Eval("STT") %></td>
                                                                <td><%#Eval("BIENPHAPGQ") %></td>
                                                                <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYGQ_YC")) %></td>
                                                                <td>
                                                                    <asp:Literal ID="lttNoiTiepNhan" runat="server"></asp:Literal></td>
                                                                <td><asp:LinkButton ID="lblDownload" OnClick="lbtDownload_Click" runat="server" Text='<%#Eval("TENFILE") %>' CausesValidation="false" CommandName="Download"
                                                                CommandArgument='<%#Eval("FILEID") %>' CssClass="TenFile_css"></asp:LinkButton></td>
                                                                <td><%# Eval("NguoiTao") %></td>
                                                                <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayTao")) %></td>
                                                                <td align="center">
                                                                    <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                                        CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                                    &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"
                                                                        OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                                </td>
                                                            </tr>
                                                        </ItemTemplate>
                                                        <FooterTemplate></table></FooterTemplate>
                                                    </asp:Repeater>--%>
                                                </div>
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
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                            <%--<div style="margin: 5px; width: 99%;">
                                <uc2:DONGHEP runat="server" ID="DONGHEP" />
                            </div>--%>
                            <asp:Panel ID="pnThuLy" runat="server" Visible="false">
                                <div class="boxchung">
                                    <h4 class="tleboxchung">Thông tin án phí</h4>
                                    <div class="boder" style="padding: 10px;">
                                        <table class="table1">
                                            <tr>
                                                <td class="lable_td">Đương sự</td>
                                                <td style="width: 260px;">
                                                    <asp:DropDownList ID="ddlDuongSu" CssClass="chosen-select" runat="server"
                                                        Width="250px" AutoPostBack="True">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Miễn án phí?</td>
                                                <td colspan="3">
                                                    <asp:CheckBox ID="chkNopAnPhi" runat="server" Text=""
                                                        AutoPostBack="True" OnCheckedChanged="chkNopAnPhi_CheckedChanged" /></td>
                                            </tr>
                                            <tr>
                                                <td class="lable_td">Giá trị tranh chấp</td>
                                                <td style="width: 260px;">
                                                    <asp:TextBox ID="txtGiaTriTranhChap" runat="server" CssClass="user text_Right_css" Width="242px" onkeyup="javascript:this.value=Comma(this.value);" AutoPostBack="True" OnTextChanged="txtGiaTriTranhChap_TextChanged" onkeypress="return isNumber(event)"></asp:TextBox>
                                                </td>
                                                <td class="lable_td">Mức giảm án phí</td>
                                                <td>
                                                    <asp:TextBox ID="txtMucGiamAnPhi" runat="server" CssClass="user text_Right_css" Width="150"
                                                        onkeyup="javascript:this.value=Comma(this.value);" onkeypress="return isNumber(event)" AutoPostBack="True" OnTextChanged="txtMucGiamAnPhi_TextChanged"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <%--  <td>Án phí</td>
                                                <td>
                                                    <asp:TextBox ID="txtAnPhi" runat="server" CssClass="user text_Right_css" Width="242px" onkeyup="javascript:this.value=Comma(this.value);" onkeypress="return isNumber(event)"></asp:TextBox>
                                                </td>--%>
                                                <td class="lable_td">Tạm ứng án phí<span class="must_input">(*)</span></td>
                                                <td>
                                                    <asp:TextBox ID="txtTamUngAnPhi" runat="server" CssClass="user text_Right_css" Width="242" onkeyup="javascript:this.value=Comma(this.value);" onkeypress="return isNumber(event)"></asp:TextBox>
                                                </td>

                                                <td style="width: 128px;">Hạn nộp (số ngày)<span class="must_input">(*)</span></td>
                                                <td>
                                                    <asp:TextBox ID="txtHanNopAnPhi" runat="server" CssClass="user text_Right_css"
                                                        Width="150px" MaxLength="10"
                                                        onkeypress="return isNumber(event)"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 128px;">Ngày thông báo<span class="batbuoc">(*)</span></td>
                                                <td>
                                                    <asp:TextBox ID="txtNgaythongbaoAP" runat="server" CssClass="user" Width="152px" MaxLength="10" AutoPostBack="true" OnTextChanged="txtNgaythongbaoAP_TextChanged"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgaythongbaoAP" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaythongbaoAP" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                                <td>Số ngày gia hạn</td>
                                                <td>
                                                    <asp:TextBox ID="txtSoNgayGiaHan" runat="server" CssClass="user text_Right_css" Width="242px" MaxLength="3" onkeypress="return isNumber(event)"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="lable_td">Số thông báo<span class="must_input">(*)</span></td>
                                                <td style="width: 242px;">
                                                    <asp:TextBox ID="txtSothongbaoAP" runat="server" CssClass="user" Width="242px"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <asp:Panel runat="server" ID="pnDownload" Visible="false">
                                                <tr>
                                                    <td>Tệp đính kèm</td>
                                                    <td>
                                                        <asp:HiddenField ID="hddFilePath" runat="server" />
                                                        <asp:CheckBox ID="chkKySo" Checked="true" runat="server" onclick="CheckKyso();" Text="Sử dụng ký số file đính kèm" />
                                                        <br />
                                                        <asp:HiddenField ID="hddFileKySo" runat="server" Value="" />
                                                        <asp:HiddenField ID="hddSessionID" runat="server" />
                                                        <asp:HiddenField ID="hddURLKS" runat="server" />
                                                        <div id="zonekyso" style="margin-bottom: 5px; margin-top: 10px;">
                                                            <button type="button" class="buttonkyso" id="TruongPhongKyNhay" onclick="exc_sign_file1();">Chọn file đính kèm và ký số</button>
                                                            <button type="button" class="buttonkyso" id="_Config" onclick="vgca_show_config();">Cấu hình CKS</button><br />
                                                            <ul id="file_name" style="list-style: none; margin: 0px 0px 0px 0px; padding: 0px 0px 0px 0px; line-height: 18px;">
                                                            </ul>
                                                        </div>
                                                        <div id="zonekythuong" style="display: none; margin-top: 10px; width: 80%;">
                                                            <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                                                ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                                            <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td></td>
                                                    <td>
                                                        <asp:LinkButton ID="lbtDownload" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownload_Click"></asp:LinkButton></td>
                                                </tr>
                                            </asp:Panel>
                                            <tr>
                                                <td colspan="6">
                                                    <div style="text-align: center;">

                                                        <asp:Button ID="cmdCapNhatAP" runat="server"
                                                            CssClass="buttoninput" Text="Lưu" OnClick="cmdCapNhatAP_Click" />
                                                        <asp:Button ID="cmdThemmoiAP" runat="server" CssClass="buttoninput" Text="Làm mới"
                                                            OnClick="btnThemmoiAP_Click" />
                                                         <asp:Button ID="cmdLoadAP" runat="server" Style="display: none;" disable="false" OnClick="cmdLoadAP_Click" />
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <asp:Label runat="server" ID="lbThongbaoAP" ForeColor="Red" Style="margin-left: 15px;"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="6">
                                                    <asp:HiddenField ID="hddCurrAPID" runat="server" />
                                                    <div class="phantrang">
                                                        <div class="sobanghi">
                                                            <asp:Literal ID="lstSobanghiTAP" runat="server"></asp:Literal>
                                                        </div>
                                                        <div class="sotrang">
                                                            <asp:LinkButton ID="lbTBackAP" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                                                OnClick="lbTBackAP_Click"></asp:LinkButton>
                                                            <asp:LinkButton ID="lbTFirstAP" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                                                Text="1" OnClick="lbTFirstAP_Click"></asp:LinkButton>
                                                            <asp:Label ID="lbTStep1AP" runat="server" Text="..." Visible="false"></asp:Label>
                                                            <asp:LinkButton ID="lbTStep2AP" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                                Text="2" OnClick="lbTStepAP_Click"></asp:LinkButton>
                                                            <asp:LinkButton ID="lbTStep3AP" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                                Text="3" OnClick="lbTStepAP_Click"></asp:LinkButton>
                                                            <asp:LinkButton ID="lbTStep4AP" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                                Text="4" OnClick="lbTStepAP_Click"></asp:LinkButton>
                                                            <asp:LinkButton ID="lbTStep5AP" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                                Text="5" OnClick="lbTStepAP_Click"></asp:LinkButton>
                                                            <asp:Label ID="lbTStep6AP" runat="server" Text="..." Visible="false"></asp:Label>
                                                            <asp:LinkButton ID="lbTLastAP" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                                Text="100" OnClick="lbTLastAP_Click"></asp:LinkButton>
                                                            <asp:LinkButton ID="lbTNextAP" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                                                OnClick="lbTNextAP_Click"></asp:LinkButton>
                                                        </div>
                                                    </div>
                                                    <div>
                                                        <asp:DataGrid ID="rptAP" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                            PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                                            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                                            ItemStyle-CssClass="chan" Width="100%"
                                                            OnItemCommand="rptAP_ItemCommand" OnItemDataBound="rptAP_ItemDataBound">
                                                            <Columns>
                                                                <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                                    <HeaderTemplate>
                                                                        TT
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <%# Container.DataSetIndex + 1 %>
                                                                    </ItemTemplate>
                                                                </asp:TemplateColumn>
                                                                <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                                                    <HeaderTemplate>
                                                                        Nguyên đơn/ Người KK
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <%#Eval("DUONGSU") %>
                                                                    </ItemTemplate>
                                                                </asp:TemplateColumn>
                                                                <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Right">
                                                                    <HeaderTemplate>
                                                                        Tạm ứng AP
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <%#Eval("TAMUNGAP") %>
                                                                    </ItemTemplate>
                                                                </asp:TemplateColumn>
                                                                <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                                    <HeaderTemplate>
                                                                        Ngày nộp tạm ứng án phí
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYNOPANPHI")) %>
                                                                    </ItemTemplate>
                                                                </asp:TemplateColumn>
                                                                <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                                                    <HeaderTemplate>
                                                                        Người nộp
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <%#Eval("NGUOINOP") %>
                                                                    </ItemTemplate>
                                                                </asp:TemplateColumn>
                                                                <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="center">
                                                                    <HeaderTemplate>
                                                                        Số biên lai
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <%#Eval("SOBIENLAI") %>
                                                                    </ItemTemplate>
                                                                </asp:TemplateColumn>
                                                                <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="175px">
                                                                    <HeaderTemplate>Biên lai đính kèm</HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <div>
                                                                            <i>Mã thông báo:</i>
                                                                            <b><%#Eval("MA_THONGBAO") %></b>
                                                                        </div>
                                                                        <div style="margin-top: 5px;">
                                                                            <asp:ImageButton ID="lblDownloadAP" ImageUrl="/UI/img/Manager/file_attach_pdf.gif" runat="server" CausesValidation="false" CommandName="DownloadAP"
                                                                                CommandArgument='<%#Eval("FILEID") %>' ToolTip='<%#Eval("TENFILE")%>' />
                                                                            <asp:HiddenField ID="hd_DownloadAP" runat="server" Value='<%#Eval("MA_THONGBAO").ToString()+";"+Eval("DVCQG_TT_ID") %>' />
                                                                        </div>
                                                                    </ItemTemplate>
                                                                </asp:TemplateColumn>
                                                                <asp:TemplateColumn HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center">
                                                                    <HeaderTemplate>
                                                                        Người tạo
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <%# Eval("NguoiTao") %>
                                                                    </ItemTemplate>
                                                                </asp:TemplateColumn>
                                                                <asp:TemplateColumn HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                                    <HeaderTemplate>
                                                                        Ngày tạo
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <%# string.Format("{0:dd/MM/yyyy}",Eval("NgayTao")) %>
                                                                    </ItemTemplate>
                                                                </asp:TemplateColumn>
                                                                <asp:TemplateColumn HeaderStyle-Width="105px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                                    <HeaderTemplate>
                                                                        Thao tác
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lblSuaAP" runat="server" Text="Sửa" CausesValidation="false" CommandName="SuaAP" ForeColor="#0e7eee"
                                                                            CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                                        &nbsp;&nbsp;<asp:LinkButton ID="lbtXoaAP" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee" CommandName="XoaAP"
                                                                            CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                                        <br/>
                                                                        <asp:LinkButton ID="lbtLSTBAnPhi" runat="server" Text="Lịch sử TBAP" CausesValidation="false" CommandName="LSTBAnPhi" ForeColor="#0e7eee"
                                                                            CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
																			
                                                                        </ItemTemplate>
                                                                </asp:TemplateColumn>
                                                                <asp:BoundColumn DataField="TOA_GIAIQUYET_ID" Visible="false"></asp:BoundColumn>
                                                            </Columns>
                                                            <HeaderStyle CssClass="header"></HeaderStyle>
                                                            <ItemStyle CssClass="chan"></ItemStyle>
                                                            <PagerStyle Visible="false"></PagerStyle>
                                                        </asp:DataGrid>
                                                    </div>
                                                    <div class="phantrang">
                                                        <div class="sobanghi">
                                                            <asp:Literal ID="lstSobanghiBAP" runat="server"></asp:Literal>
                                                        </div>
                                                        <div class="sotrang">
                                                            <asp:LinkButton ID="lbBBackAP" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                                                OnClick="lbTBackAP_Click"></asp:LinkButton>
                                                            <asp:LinkButton ID="lbBFirstAP" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                                                Text="1" OnClick="lbTFirstAP_Click"></asp:LinkButton>
                                                            <asp:Label ID="lbBStep1AP" runat="server" Text="..." Visible="false"></asp:Label>
                                                            <asp:LinkButton ID="lbBStep2AP" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                                Text="2" OnClick="lbTStepAP_Click"></asp:LinkButton>
                                                            <asp:LinkButton ID="lbBStep3AP" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                                Text="3" OnClick="lbTStepAP_Click"></asp:LinkButton>
                                                            <asp:LinkButton ID="lbBStep4AP" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                                Text="4" OnClick="lbTStepAP_Click"></asp:LinkButton>
                                                            <asp:LinkButton ID="lbBStep5AP" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                                Text="5" OnClick="lbTStepAP_Click"></asp:LinkButton>
                                                            <asp:Label ID="lbBStep6AP" runat="server" Text="..." Visible="false"></asp:Label>
                                                            <asp:LinkButton ID="lbBLastAP" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                                Text="100" OnClick="lbTLastAP_Click"></asp:LinkButton>
                                                            <asp:LinkButton ID="lbBNextAP" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                                                OnClick="lbTNextAP_Click"></asp:LinkButton>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>

                                </div>
                            </asp:Panel>
                        </td>
                    </tr>
                    <%-- <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung"></h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>--%>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            $(function () {
                var urldmHanhchinh = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/SearchTopToaAn") %>';

                $("[id$=txtToaAn]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldmHanhchinh, data: "{ 'textsearch': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                            success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                        });
                    },
                    select: function (e, i) { $("[id$=hddToaAn]").val(i.item.val); }, minLength: 1
                });

            });

            //------------------------------------------------
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }

        }
        function Validate() {
            var txtNgayGQ = document.getElementById('<%= txtNgayGQ.ClientID%>');
            if (!CheckDateTimeControl(txtNgayGQ, "ngày GQ/YC"))
                return false;
            var NgayGQ = txtNgayGQ.value;
            var hddNgayNhanDon = document.getElementById('<%=hddNgayNhanDon.ClientID%>');
            var NgayNhanDon;
            if (hddNgayNhanDon.value != "") {
                arr = hddNgayNhanDon.value.split('/');
                NgayNhanDon = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (NgayGQ < NgayNhanDon) {
                    alert('Ngày GQ/YC không được nhỏ hơn ngày nhận đơn ' + hddNgayNhanDon.value + '.');
                    txtNgayGQ.focus();
                    return false;
                }
            }
            //-----------------------------
            var dropBienPhapGQ = document.getElementById('<%=dropBienPhapGQ.ClientID%>');
            var bienphap = dropBienPhapGQ.options[dropBienPhapGQ.selectedIndex].value;
            var CDTrongNganh = 1, CDNgoaiNganh = 2, TraLaiDon = 3, YCBoSung = 4, ThuLy = 5;
            if (bienphap == CDTrongNganh) {
                var hddToaAn = document.getElementById('<%= hddToaAn.ClientID %>');
                var txtToaAn = document.getElementById('<%= txtToaAn.ClientID %>');
                if (hddToaAn.value == '' || hddToaAn.value == "0") {
                    alert('Bạn cần chọn tòa án nhận.');
                    txtToaAn.focus();
                    return false;
                }
            }
            else if (bienphap == TraLaiDon) {
                var txtTradon_Ngay = document.getElementById('<%=txtTradon_Ngay.ClientID%>');
                if (Common_CheckEmpty(txtTradon_Ngay.value)) {
                    if (!Common_IsTrueDate(txtTradon_Ngay.Value))
                        return false;
                    if (!Sosanh2Date(txtTradon_Ngay, "Ngày trả đơn", NgayGQ, "Ngày GQ/YC"))
                        return false;
                }
            }
            else if (bienphap == YCBoSung) {
                var txtYCBS = document.getElementById('<%=txtYCBS.ClientID%>');
                if (Common_CheckEmpty(txtYCBS.value)) {
                    if (txtYCBS.value.length > 1000) {
                        alert('Yêu cầu bổ sung không quá 1000 ký tự.');
                        txtYCBS.focus();
                        return false;
                    }
                }
            }
            else if (bienphap == ThuLy) {
                <%--var chkNopAnPhi = document.getElementById('<%= chkNopAnPhi.ClientID %>');
                if (!chkNopAnPhi.checked) {
                    var txtTamUngAnPhi = document.getElementById('<%= txtTamUngAnPhi.ClientID %>');
                    if (!Common_CheckEmpty(txtTamUngAnPhi.value)) {
                        alert('Bạn cần nhập tạm ứng án phí.');
                        txtTamUngAnPhi.focus();
                        return false;
                    }

                    var txtHanNopAnPhi = document.getElementById('<%=txtHanNopAnPhi.ClientID%>');
                    if (!Common_CheckEmpty(txtHanNopAnPhi.value)) {
                        alert('Bạn cần nhập hạn nộp án phí.');
                        txtTamUngAnPhi.focus();
                        return false;
                    }
                }--%>
            }
            var txtSothongbao = document.getElementById('<%= txtSothongbao.ClientID %>');
            if (!Common_CheckTextBox(txtSothongbao, "Số thông báo")) {
                return false;
            }
            var txtLyDo = document.getElementById('<%= txtLyDo.ClientID %>');
            if (txtLyDo.value.length > 500) {
                var msg = '';
                if (bienphap == TraLaiDon)
                    msg = 'Ghi chú không quá 500 ký tự';
                else
                    msg = 'Lý do không quá 500 ký tự';
                alert(msg);
                txtLyDo.focus();
                return false;
            }
            return true;
        }
		   function LoadModalDiv() {
            var bcgDiv = document.getElementById("divBackground");
            bcgDiv.style.display = "block";
            if (bcgDiv != null) {

                if (document.body.clientHeight > document.body.scrollHeight) {

                    bcgDiv.style.height = document.body.clientHeight + "px";
                }
                else {

                    bcgDiv.style.height = document.body.scrollHeight + "px";
                }
                bcgDiv.style.width = "100%";
            }
        }

        function HideModalDiv() {
            var bcgDiv = document.getElementById("divBackground");
            bcgDiv.style.display = "none";
            $("#<%= cmdLoad.ClientID %>").click();
        }
        
        function HideModalDivAP() {
            var bcgDiv = document.getElementById("divBackground");
            bcgDiv.style.display = "none";
            $("#<%= cmdLoadAP.ClientID %>").click();
        }
        
    </script>
    <script>
        var count_file = 0;
        function CheckKyso() {
            var chkKySo = document.getElementById('<%=chkKySo.ClientID%>');
            if (chkKySo.checked) {
                document.getElementById("zonekyso").style.display = "";
                document.getElementById("zonekythuong").style.display = "none";
            }
            else {
                document.getElementById("zonekyso").style.display = "none";
                document.getElementById("zonekythuong").style.display = "";
            }
        }
        function VerifyPDFCallBack(rv) {

        }
        function exc_verify_pdf1() {
            var prms = {};
            var hddSession = document.getElementById('<%=hddSessionID.ClientID%>');
            prms["SessionId"] = "";
            prms["FileName"] = document.getElementById("file1").value;
            var json_prms = JSON.stringify(prms);
            vgca_verify_pdf(json_prms, VerifyPDFCallBack);
        }
        function SignFileCallBack1(rv) {
            var received_msg = JSON.parse(rv);
            if (received_msg.Status == 0) {
                var hddFilePath = document.getElementById('<%=hddFilePath.ClientID%>');
                var new_item = document.createElement("li");
                new_item.innerHTML = received_msg.FileName;
                hddFilePath.value = received_msg.FileServer;
                //-------------Them icon xoa file------------------
                var del_item = document.createElement("img");
                del_item.src = '/UI/img/xoa.gif';
                del_item.style.width = "15px";
                del_item.style.margin = "5px 0 0 5px";
                del_item.onclick = function () {
                    if (!confirm('Bạn muốn xóa file này?')) return false;
                    document.getElementById("file_name").removeChild(new_item);
                }
                del_item.style.cursor = 'pointer';
                new_item.appendChild(del_item);

                document.getElementById("file_name").appendChild(new_item);
            } else {
                document.getElementById("_signature").value = received_msg.Message;
            }
        }
        //metadata có kiểu List<KeyValue> 
        //KeyValue là class { string Key; string Value; }
        function exc_sign_file1() {
            var prms = {};
            var scv = [{ "Key": "abc", "Value": "abc" }];
            var hddURLKS = document.getElementById('<%=hddURLKS.ClientID%>');
            prms["FileUploadHandler"] = hddURLKS.value.replace(/^http:\/\//i, window.location.protocol + '//');
            prms["SessionId"] = "";
            prms["FileName"] = "";
            prms["MetaData"] = scv;
            var json_prms = JSON.stringify(prms);
            vgca_sign_file(json_prms, SignFileCallBack1);
        }
        function RequestLicenseCallBack(rv) {
            var received_msg = JSON.parse(rv);
            if (received_msg.Status == 0) {
                document.getElementById("_signature").value = received_msg.LicenseRequest;
            } else {
                alert("Ký số không thành công:" + received_msg.Status + ":" + received_msg.Error);
            }
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
    </script>
</asp:Content>

