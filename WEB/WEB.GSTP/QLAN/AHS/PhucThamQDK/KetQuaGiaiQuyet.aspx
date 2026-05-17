<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="KetQuaGiaiQuyet.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.PhucThamQDK.KetQuaGiaiQuyet" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>
    <script src="../../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddShowBA" Value="1" runat="server" />
    <asp:HiddenField ID="hddNgayNhanPhanCong" Value="" runat="server" />
    <asp:HiddenField ID="hddThoiHanThang" Value="0" runat="server" />
    <asp:HiddenField ID="hddThoiHanNgay" Value="0" runat="server" />
    <asp:HiddenField ID="ttBanDauDONKK_USER_DKNHANVB" runat="server" Value="0" />
    <asp:HiddenField ID="hddVuAnID" runat="server" Value="0" />
    <asp:HiddenField ID="hddID" runat="server" Value="0" />
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
    <asp:HiddenField ID="hddIsSuaDoi" Value="1" runat="server" />
    <style>
        .align_right {
            text-align: right;
        }

        .phantrang_bottom {
            display: block;
            line-height: 20px;
            margin-bottom: 2px;
            margin-top: 5px;
            overflow: hidden;
            width: 100%;
        }

        .tleboxchung {
            text-transform: uppercase;
        }

        .col1 {
            width: 130px;
        }

        .col2 {
            width: 230px;
        }

        .col3 {
            width: 100px;
        }

        .ajax__calendar_container {
            width: 180px;
        }

        .ajax__calendar_body {
            width: 100%;
            height: 145px;
        }

        .QDVACol1 {
            width: 107px;
        }

        .QDVACol2 {
            width: 270px;
        }

        .QDVACol3 {
            width: 116px;
        }
    </style>
  
        <div class="box">
            <div class="box_nd">
                <div class="boxchung">
                    <h4 class="tleboxchung">THÔNG TIN QUYẾT ĐỊNH</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                        
                            <tr>
                                <td>Tên quyết định<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:DropDownList ID="ddlQuyetdinh" CssClass="chosen-select" runat="server" Width="650px"
                                        AutoPostBack="True" ClientIDMode="AutoID" OnSelectedIndexChanged="ddlQuyetdinh_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td class="QDVACol1">Ngày mở phiên tòa<span class="batbuoc">(*)</span></td>
                                <td class="QDVACol2">
                                    <asp:TextBox ID="txtNgayMoPhienToa" runat="server" CssClass="user"
                                        Width="100px"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayMoPhienToa"
                                        Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayMoPhienToa"
                                        Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td class="QDVACol3">Địa điểm</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtDiaDiem" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                </td>
                            </tr>

                            <asp:Panel ID="pnKetquaPhuctham" runat="server" visible="false">
                                <tr>
                                    <td>Kết quả phúc thẩm<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddlKetquaQuyetdinh" CssClass="chosen-select" runat="server" Width="450px" AutoPostBack="true" OnSelectedIndexChanged="ddlKetquaQuyetdinh_SelectedIndexChanged"></asp:DropDownList>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <asp:Panel ID="pnLyDoKetquaPhuctham" runat="server" visible="false">
                                <tr>
                                    <td>Lý do<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddlLydoQuyetdinh" CssClass="chosen-select" runat="server" Width="450px"></asp:DropDownList>
                                    </td>
                                </tr>
                            </asp:Panel>

                            <asp:Panel ID="pnHinhThucXetXu" runat="server" Visible="false">
                                <tr>
                                    <td>Hình thức xét xử</td>
                                    <td>
                                        <asp:DropDownList ID="ddlHTXX" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="true">
                                            <asp:ListItem Text="-Chọn-" Value="0"></asp:ListItem>
                                            <asp:ListItem Text="Xử kín trực tuyến" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="Xử kín trực tiếp" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="Xử công khai trực tuyến" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="Xử công khai trực tiếp" Value="4"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </asp:Panel>


                            <asp:Panel ID="pnLyDo" runat="server">
                                <tr>
                                    <td>Lý do</td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddlLydo" CssClass="chosen-select" runat="server" Width="650px"></asp:DropDownList>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <asp:Panel ID="pntxtLydo" runat="server">
                                <tr>
                                    <td id="lbtxtLydo" runat="server"></td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtLydo" CssClass="user" placeholder="" runat="server" Width="640px" MaxLength="500" TextMode="MultiLine"></asp:TextBox>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <asp:Panel ID="pnLyDo_BM03" runat="server" Visible="false">
                                <tr>
                                    <td>Lý do</td>
                                    <td>
                                        <asp:DropDownList ID="ddlLydo_BM03" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                    </td>
                                    <td>Thay đổi</td>
                                    <td>
                                        <asp:DropDownList ID="ddlThayDoi" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="true" OnSelectedIndexChanged="ddlThayDoi_SelectedIndexChanged">
                                            <asp:ListItem Text="Thẩm phán" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="Hội thẩm" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="Thư ký" Value="3"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Người được phân công</td>
                                    <td>
                                        <asp:DropDownList ID="ddlNguoiDuocPC" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="true" OnSelectedIndexChanged="ddlNguoiDuocPC_SelectedIndexChanged"></asp:DropDownList>
                                    </td>
                                    <td>Người bị thay đổi</td>
                                    <td>
                                        <asp:DropDownList ID="ddlNguoiBiThayDoi" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <tr>
                                <td>Có công bố quyết định?<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:RadioButtonList ID="rdCongBoQD" AutoPostBack="true"
                                        runat="server" RepeatDirection="Horizontal"
                                        OnSelectedIndexChanged="rdCongboQD_SelectedIndexChanged">
                                        <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <asp:PlaceHolder ID="phNguoiKyDdl" runat="server" Visible="false">
                                <tr>
                                    <td>Người ký<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddlNguoiky" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                    </td>

                                </tr>
                            </asp:PlaceHolder>
                            <asp:PlaceHolder ID="phNguoiKyTxt" runat="server" Visible="true">
                                <tr>
                                    <td>Người ký</td>
                                    <td>
                                        <asp:TextBox ID="txtNguoiKyQDVV" CssClass="user" Enabled="false" runat="server"
                                            Width="242px" MaxLength="250"></asp:TextBox></td>
                                    <td>Chức vụ</td>
                                    <td>
                                        <asp:TextBox ID="txtChucvu" CssClass="user" Enabled="false" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                </tr>
                            </asp:PlaceHolder>

                            <tr>
                                <td class="QDVACol1">Số Quyết định<span class="batbuoc">(*)</span></td>
                                <td class="QDVACol2">
                                    <asp:TextBox ID="txtSoQD" runat="server" CssClass="user align_right"
                                        Width="242px" MaxLength="50"></asp:TextBox>
                                </td>
                                <td class="QDVACol3">Ngày quyết định<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgayQD" runat="server"  CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayQD" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>
                                <td>Hiệu lực từ ngày</td>
                                <td>
                                    <asp:TextBox ID="txtHieulucTuNgay" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtHieulucTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtHieulucTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td>Hiệu lực đến ngày</td>
                                <td>
                                    <asp:TextBox ID="txtHieuLucDenNgay" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtHieuLucDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtHieuLucDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>
                                <td>Tệp đính kèm</td>
                                <td>
                                    <asp:HiddenField ID="hddFilePathQD" runat="server" />
                                    <cc1:AsyncFileUpload ID="AsyncFileUpLoadQD" CssClass="floatF" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedCompleteQD"
                                        ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                    <%--<asp:Image ID="Image1" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />--%>
                                    <asp:LinkButton ID="lbtAddFile" CssClass="linkAddFile" Visible="false" runat="server" Text="Thêm tệp đính kèm"></asp:LinkButton>
                                </td>
                            </tr>
                            <%--<tr>
                            <td>File đính kèm</td>
                            <td colspan="3">
                                <asp:HiddenField ID="HiddenField1" runat="server" />
                                <asp:CheckBox ID="chkKySo" Visible="false" Checked="true" runat="server" onclick="CheckKyso();" Text="Sử dụng ký số file đính kèm" />
                                <br />
                                <asp:HiddenField ID="HiddenField2" runat="server" Value="" />
                                <asp:HiddenField ID="HiddenField3" runat="server" />
                                <asp:HiddenField ID="HiddenField4" runat="server" />
                                <div id="zonekyso" style="display: none; margin-bottom: 5px; margin-top: 10px;">
                                    <button type="button" class="buttonkyso" id="TruongPhongKyNhay" onclick="exc_sign_file1();">Chọn file đính kèm và ký số</button>
                                    <button type="button" class="buttonkyso" id="_Config" onclick="vgca_show_config();">Cấu hình CSK</button><br />
                                    <ul id="file_name" style="list-style: none; margin: 0px 0px 0px 0px; padding: 0px 0px 0px 0px; line-height: 18px;">
                                    </ul>
                                </div>
                                <div id="zonekythuong" style="margin-top: 10px; width: 80%;">
                                    <cc1:AsyncFileUpload ID="AsyncFileUpLoad1" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                        ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                    <asp:Image ID="Image1" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                </div>
                            </td>
                        </tr>--%>
                            <tr>
                                <td></td>
                                <td colspan="3">
                                    <asp:LinkButton ID="LinkButton1" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownload_Click"></asp:LinkButton></td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="truong">
                    <table class="table1">
                        <tr>
                            <td colspan="2" style="text-align: center;">
                                <asp:Button ID="btnUpdate" runat="server" CssClass="buttoninput"
                                    Text="Lưu" OnClientClick="return ValidInputData();" OnClick="btnUpdate_Click" />
                                <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:Label ID="lbThongBaoQD" runat="server" ForeColor="Red"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div>
                                    <asp:HiddenField ID="hddidQD" runat="server" Value="0" />
                                    <asp:HiddenField ID="hddNguoiKyTxtID" runat="server" Value="0" />
                                    <asp:HiddenField ID="hddNguoiKyQDID" runat="server" Value="0" />
<%--                                    <asp:Label runat="server" ID="lbThongBaoQD" ForeColor="Red"></asp:Label>--%>
                                </div>
                                <asp:Panel runat="server" ID="pndataQD" Visible="false">

                                    <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                        PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                        CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                        ItemStyle-CssClass="chan" Width="100%"
                                        OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
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
                                                    Tên Quyết định
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%#Eval("TenQD") %>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="SOQUYETDINH" HeaderText="Số QĐ" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="NGAYQD" HeaderText="Ngày ra QĐ" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="NguoiKy" HeaderText="Người ký" HeaderStyle-Width="95px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="TENTOAAN" HeaderText="Tòa án ra QĐ" HeaderStyle-Width="125px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="NGUOITAO" HeaderText="Người tạo" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="NGAYTAO" HeaderText="Ngày tạo" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>
                                            <%--<asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                    <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lblDownload" runat="server" Text='<%#Eval("TENFILE") %>' CausesValidation="false" CommandName="Download"
                                            CommandArgument='<%#Eval("FILEID") %>' CssClass="TenFile_css"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateColumn>--%>
                                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                                <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:ImageButton ID="lblDownload" ImageUrl="~/UI/img/ghim.png" runat="server" CausesValidation="false" CommandName="DownloadQD"
                                                        CommandArgument='<%#Eval("FILEID") %>' ToolTip='<%#Eval("TENFILE")%>' UseSubmitBehavior="False" />
                                                    <%--<asp:LinkButton ID="lblDownload" runat="server" Text='<%#Eval("TENFILE") %>'  CssClass="TenFile_css"></asp:LinkButton>--%>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    Thao tác
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                        CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                    &nbsp;&nbsp;
                                                    <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                        ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="TOA_GIAIQUYET_ID" Visible="false"></asp:BoundColumn>
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



        function validate() {
           <%-- var txtNgayMoPhienToa = document.getElementById('<%=txtNgayMoPhienToa.ClientID%>');
            if (!Common_CheckEmpty(txtNgayMoPhienToa.value)) {
                alert('Bạn chưa nhập "Ngày mở phiên tòa".Hãy kiểm tra lại!');
                txtNgayMoPhienToa.focus();
                return false;
            }
            //--------------
            var txtDiaDiem = document.getElementById('<%=txtDiaDiem.ClientID%>');
            if (!Common_CheckEmpty(txtDiaDiem.value)) {
                alert('Bạn chưa chọn "Địa điểm".Hãy kiểm tra lại!');
                txtDiaDiem.focus();
                return false;
            }
            //--------------
            var txtNgayBanAn = document.getElementById('<%=txtNgayBanAn.ClientID%>');
            if (!Common_CheckEmpty(txtNgayBanAn.value)) {
                alert('Bạn chưa chọn mục "Ngày bản án". Hãy kiểm tra lại!');
                txtNgayBanAn.focus();
                return false;
            }
            //----------------------
            var ddlKetQuaPhucTham = document.getElementById('<%=ddlKetQuaPhucTham.ClientID%>');
            var val = ddlKetQuaPhucTham.options[ddlKetQuaPhucTham.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn kết quả phúc thẩm. Hãy chọn lại!');
                ddlKetQuaPhucTham.focus();
                return false;
            }
            var ddlLyDoBanAn = document.getElementById('<%=ddlLyDoBanAn.ClientID%>');
            var val = ddlLyDoBanAn.options[ddlLyDoBanAn.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn nguyên nhân. Hãy chọn lại!');
                ddlLyDoBanAn.focus();
                return false;
            }
            //--------------
            var hddNguoiKyID = document.getElementById('<%=hddNguoiKyID.ClientID%>');
            var txtNguoiKy = document.getElementById('<%=txtNguoiKy.ClientID%>');
            if (!Common_CheckEmpty(hddNguoiKyID.value)) {
                alert('Bạn chưa chọn mục "Người ký". Hãy kiểm tra lại!');
                txtNguoiKy.focus();
                return false;
            }
            return true;--%>
        }
        function validate_chitieu_tk() {
            <%--//------------------
            if (!validate_CheckRadio())
                return false;
            //--------------
            var txtSBC_GIUNGUYEN_AN_ST = document.getElementById('<%=txtSBC_GIUNGUYEN_AN_ST.ClientID%>');
            if (!Common_CheckEmpty(txtSBC_GIUNGUYEN_AN_ST.value)) {
                alert('Bạn chưa nhập "Số bị cáo TA giữ nguyên án sơ thẩm, không chấp nhận K.N của VKS"');
                txtSBC_GIUNGUYEN_AN_ST.focus();
                return false;
            }
            //--------------
            var txtSBC_SUA_AN_ST = document.getElementById('<%=txtSBC_SUA_AN_ST.ClientID%>');
            if (!Common_CheckEmpty(txtSBC_SUA_AN_ST.value)) {
                alert('Bạn chưa nhập "Số bị cáo TA sửa án sơ thẩm, không theo hướng K.N của VKS"!');
                txtSBC_SUA_AN_ST.focus();
                return false;
            }
            //--------------
            var txtSBC_CHAPNHAN_TOANBO = document.getElementById('<%=txtSBC_CHAPNHAN_TOANBO.ClientID%>');
            if (!Common_CheckEmpty(txtSBC_CHAPNHAN_TOANBO.value)) {
                alert('Bạn chưa nhập "Số bị cáo TA chấp nhận toàn bộ K.N của VKS"!');
                txtSBC_CHAPNHAN_TOANBO.focus();
                return false;
            }
            //--------------
            var txtSBC_CHAPNHAN_MOTPHAN = document.getElementById('<%=txtSBC_CHAPNHAN_MOTPHAN.ClientID%>');
            if (!Common_CheckEmpty(txtSBC_CHAPNHAN_MOTPHAN.value)) {
                alert('Bạn chưa nhập "Số bị cáo TA chấp nhận một phần K.N của VKS"!');
                txtSBC_CHAPNHAN_MOTPHAN.focus();
                return false;
            }
            return true;--%>
        }
        function validate_CheckRadio() {
            <%--//-----------------------------
            var rdAnLe = document.getElementById('<%=rdAnLe.ClientID%>');
            msg = 'Mục "Có áp dụng Án lệ"  bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdAnLe, msg))
                return false;
            //-----------------------------
            var rdAnRutGon = document.getElementById('<%=rdAnRutGon.ClientID%>');
            msg = 'Mục "Án rút gọn"  bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdAnRutGon, msg))
                return false;
            //-----------------------------
            var rdBaoLucGD = document.getElementById('<%=rdBaoLucGD.ClientID%>');
            msg = 'Mục "Bạo lực gia đình"  bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdBaoLucGD, msg))
                return false;
            //-----------------------------
            var rdXetXuLuuDong = document.getElementById('<%=rdXetXuLuuDong.ClientID%>');
            msg = 'Mục "Xét xử lưu động"  bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdXetXuLuuDong, msg))
                return false;
            //-----------------------------
            var rdSuaHinhPhatBS = document.getElementById('<%=rdSuaHinhPhatBS.ClientID%>');
            msg = 'Mục "Sửa phần hình phạt bổ sung hoặc áp dụng các biện pháp tư pháp" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdSuaHinhPhatBS, msg))
                return false;
            //-----------------------------
            var rdSuaBoiThuongTH = document.getElementById('<%=rdSuaBoiThuongTH.ClientID%>');
            msg = 'Mục "Sửa phần bồi thường thiệt hại và quyết định xử lý vật chứng" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdSuaBoiThuongTH, msg))
                return false;
            //-----------------------------
            var rdSuaKhac = document.getElementById('<%=rdSuaKhac.ClientID%>');
            msg = 'Mục "Sửa các phần khác" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdSuaKhac, msg))
                return false;
            //-----------------------------
            var rdSuaQDAnSoTham = document.getElementById('<%=rdSuaQDAnSoTham.ClientID%>');
            msg = 'Mục "Sửa quyết định của bản án sơ thẩm đối với bị cáo không có kháng cáo, kháng nghị" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdSuaQDAnSoTham, msg))
                return false;
            //----------------------------            
            var rdKhoiToTaiToa = document.getElementById('<%=rdKhoiToTaiToa.ClientID%>');
            msg = 'Mục "Khởi tố vụ án tại phiên tòa" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdKhoiToTaiToa, msg))
                return false;
            //----------------------------            
            var rdKoRutKhangCao = document.getElementById('<%=rdKoRutKhangCao.ClientID%>');
            msg = 'Mục "Số vụ án VKS rút kháng nghị, người có kháng cáo không rút kháng cáo" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdKoRutKhangCao, msg))
                return false;
            //-----------------------------
            var rdDuyetKhangNghiVKS = document.getElementById('<%=rdDuyetKhangNghiVKS.ClientID%>');
            msg = 'Mục "Tòa án chấp nhận kháng nghị của VKS" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdDuyetKhangNghiVKS, msg))
                return false;
            else {
                var selected_value = GetStatusRadioButtonList(rdDuyetKhangNghiVKS);
                if (selected_value == 1) {
                    var txtDuyetKN_VKS_BiCao = document.getElementById('<%=txtDuyetKN_VKS_BiCao.ClientID%>');
                    if (!Common_CheckEmpty(txtDuyetKN_VKS_BiCao.value)) {
                        alert('Bạn chưa nhập "Số bị cáo"!');
                        txtDuyetKN_VKS_BiCao.focus();
                        return false;
                    }
                }
            }
            return true;--%>
        }
    </script>
    <script>
        function popupChonToiDanh(BiCanID) {
            var BanAnID = document.getElementById('<%=hddID.ClientID%>').value;
            var link = "/QLAN/AHS/PhucTham/BanAn/popup/pToiDanh.aspx?aID=" + BanAnID + "&bID=" + BiCanID;
            var width = 900;
            var height = 650;
            PopupCenter(link, "Cập nhật điều luật áp dụng cho bị cáo", width, height);
        }

        function uploadStart(sender, args) {
            var fileName = args.get_fileName();
            var fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
            var validFilesTypes = ["exe", "dll", "msi", "bat"];
            var isValidFile = false;
            for (var i = 0; i < validFilesTypes.length; i++) {
                if (fileExt == validFilesTypes[i]) {
                    isValidFile = true;
                    break;
                }
            }
            if (isValidFile) {
                var err = new Error();
                err.name = "Lỗi tải lên";
                err.message = "Hệ thống không lưu trữ file định dạng (exe,dll,msi,bat). Hãy chọn lại!";
                throw (err);
                return false;
            } else {
                return true;
            }
        }
    </script>

    <script type="text/javascript">
        var count_file = 0;
        function CheckKyso() {
<%--            var chkKySo = document.getElementById('<%=chkKySo.ClientID%>');

            if (chkKySo.checked) {
                document.getElementById("zonekyso").style.display = "";
                document.getElementById("zonekythuong").style.display = "none";
            }
            else {
                document.getElementById("zonekyso").style.display = "none";
                document.getElementById("zonekythuong").style.display = "";
            }--%>
        }
        function VerifyPDFCallBack(rv) {

        }

        function exc_verify_pdf1() {
            <%--var prms = {};
            var hddSession = document.getElementById('<%=hddSessionID.ClientID%>');
            prms["SessionId"] = "";
            prms["FileName"] = document.getElementById("file1").value;

            var json_prms = JSON.stringify(prms);

            vgca_verify_pdf(json_prms, VerifyPDFCallBack);--%>
        }

        function SignFileCallBack1(rv) {
           <%-- var received_msg = JSON.parse(rv);
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
            }--%>
        }

        //metadata có kiểu List<KeyValue> 
        //KeyValue là class { string Key; string Value; }
        function exc_sign_file1() {
           <%-- var prms = {};
            var scv = [{ "Key": "abc", "Value": "abc" }];
            var hddURLKS = document.getElementById('<%=hddURLKS.ClientID%>');
            prms["FileUploadHandler"] = hddURLKS.value.replace(/^http:\/\//i, window.location.protocol + '//');
            prms["SessionId"] = "";
            prms["FileName"] = "";
            prms["MetaData"] = scv;
            var json_prms = JSON.stringify(prms);
            vgca_sign_file(json_prms, SignFileCallBack1);--%>
        }
        function RequestLicenseCallBack(rv) {
            var received_msg = JSON.parse(rv);
            if (received_msg.Status == 0) {
                document.getElementById("_signature").value = received_msg.LicenseRequest;
            } else {
                alert("Ký số không thành công:" + received_msg.Status + ":" + received_msg.Error);
            }
        }
        function pageLoad(sender, args) {
            $(function () {

                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            });
        }

        function Loadds_bicao() {
            <%--$("#<%= cmdReloadParent.ClientID %>").click();--%>
        }
    </script>
</asp:Content>


