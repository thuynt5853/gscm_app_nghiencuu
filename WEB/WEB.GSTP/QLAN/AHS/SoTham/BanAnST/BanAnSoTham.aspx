<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="BanAnSoTham.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.SoTham.BanAnST.BanAnSoTham" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>
    <script src="../../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddShowBA" Value="1" runat="server" />
    <asp:HiddenField ID="hddNgayNhanPhanCong" Value="" runat="server" />
    <asp:HiddenField ID="ttBanDauDONKK_USER_DKNHANVB" runat="server" Value="0" />
    <asp:HiddenField ID="hddID" runat="server" Value="0" />
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddTuCachPN" Value="1" runat="server" />
    <asp:HiddenField ID="hddBanAnID" runat="server" Value="0" />
    <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
    <asp:HiddenField ID="hddIsSuaDoi" Value="1" runat="server" />
    <asp:HiddenField ID="hddNgayThuLy" Value="" runat="server" />
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
    <asp:Panel ID="pnBAST" runat="server" ClientIDMode="AutoID">
        <div class="box">
            <div class="box_nd">
                <div class="truong">
                    <div class="boxchung">
                        <h4 class="tleboxchung">THÔNG TIN BA/QĐ</h4>
                        <div class="boder" style="padding: 10px;">
                            <asp:HiddenField ID="hddToaAnID" runat="server" Value="0" />
                            <asp:TextBox ID="txtToaAn" CssClass="user" runat="server"
                                Width="200px" ReadOnly="true" Visible="false"></asp:TextBox>
                            <table class="table1">
                                <tr>
                                    <td colspan="4">
                                        <asp:RadioButtonList ID="rdbPanelBA" runat="server" RepeatDirection="Horizontal" Font-Bold="true" AutoPostBack="true" OnSelectedIndexChanged="rdbPanelBA_SelectedIndexChanged">
                                            <asp:ListItem Value="1" Text="Bản án" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Quyết định"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="table_edit_col1" style="width: 142px;">Thụ lý<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="dropThuLyBA" CssClass="chosen-select" runat="server" Width="628" AutoPostBack="true" OnSelectedIndexChanged="dropThuLyBA_SelectedIndexChanged"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 122px;">Ngày mở phiên tòa<span class="batbuoc">(*)</span></td>
                                    <td style="width: 120px;">
                                        <asp:TextBox ID="txtNgayMoPhienToa" runat="server" CssClass="user" Width="100px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayMoPhienToa" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayMoPhienToa" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                    <td style="width: 90px;">Địa điểm<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtDiaDiem" CssClass="user" runat="server" Width="79%"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Ngày bản án<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayBanAn" runat="server" CssClass="user" Width="100px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayBanAn" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayBanAn" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                    <td>Số bản án<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtSoBanAn" CssClass="user align_right"
                                            runat="server" Width="100px"
                                            onkeypress="return isNumber(event)"></asp:TextBox>
                                    </td>

                                    <td style="width: 70px;">Người ký<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:HiddenField ID="hddNguoiKyID" runat="server" />
                                        <asp:TextBox ID="txtNguoiKy" CssClass="user" runat="server" Width="200px" Enabled="false"></asp:TextBox>
                                    </td>
                                </tr>
                                <asp:Panel ID="pnZonekythuong" runat="server">
                                    <tr>
                                        <td>Đính kèm tệp</td>
                                        <td colspan="5">
                                            <asp:HiddenField ID="hddFilePath" runat="server" />
                                            <%--<asp:CheckBox ID="chkKySo" Visible="false" Checked="true" runat="server" onclick="CheckKyso();" Text="Sử dụng ký số file đính kèm" />--%>
                                            <br />
                                            <asp:HiddenField ID="hddFileKySo" runat="server" Value="" />
                                            <asp:HiddenField ID="hddSessionID" runat="server" />
                                            <asp:HiddenField ID="hddURLKS" runat="server" />
                                            <%--  <div id="zonekyso" style="display: none; margin-bottom: 5px; margin-top: 10px;">
                                        <button type="button" class="buttonkyso" id="TruongPhongKyNhay" onclick="exc_sign_file1();">Chọn file đính kèm và ký số</button>
                                        <button type="button" class="buttonkyso" id="_Config" onclick="vgca_show_config();">Cấu hình</button><br />
                                        <ul id="file_name" style="list-style: none; margin: 0px 0px 0px 0px; padding: 0px 0px 0px 0px; line-height: 18px;">
                                        </ul>
                                    </div>--%>
                                            <div id="zonekythuong" style="margin-top: 10px; width: 80%;">
                                                <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern"
                                                    OnClientUploadStarted="onUploadStartBA"
                                                    OnClientUploadComplete="onUploadCompleteBA"
                                                    OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                                    ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                                <asp:Image ID="Throbber" runat="server"
                                                    ImageUrl="~/UI/img/loading-gear.gif" />
                                                <div id="loadingIndicatorBA" style="display: none; color: red;">Đang tải file...</div>
                                                <%--<asp:Button ID="Button1" CssClass="buttoninput" Visible="true" runat="server" Text="Download" OnClick="lbtDownload_Click" />--%>
                                            </div>
                                        </td>
                                    </tr>
                                </asp:Panel>
                                <asp:Panel ID="pnFILE_DINHKEM" runat="server">
                                    <tr>
                                        <td>File đính kèm: </td>
                                        <td colspan="5">
                                            <div style="float: left;">

                                                <div style="float: left;">
                                                    <asp:LinkButton ID="lbtDownloadBA" Visible="false"
                                                        runat="server" Text="Tải file đính kèm" ToolTip="Tải Bản án" OnClick="lbtDownload_Click"></asp:LinkButton>
                                                </div>

                                                <div style="float: left; margin-left: 15px; font-weight: bold;">
                                                    <asp:ImageButton Visible="false" ID="lbtXoaFile" runat="server" ToolTip="Xóa"
                                                        ImageUrl="/UI/img/xoa.gif" Width="17px" OnClick="lbtXoaFile_Click"
                                                        OnClientClick="return confirm('Bạn thực sự muốn xóa? ');" />
                                                </div>
                                                <div style="float: left; width: 100%; color: red">
                                                    <asp:Literal ID="MSG_file" runat="server" Text=""></asp:Literal>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </asp:Panel>
                                <tr>
                                    <td colspan="6"></td>
                                </tr>
                                <tr>
                                    <td colspan="6">
                                        <div class="boxchung">
                                            <h4 class="tleboxchung">Thông tin vụ án theo thống kê</h4>
                                            <div class="boder" style="padding: 10px;">
                                                <table class="table1">
                                                    <%--<tr>
                                                        <td colspan="2">
                                                            <div style="float: left; line-height: 28px; width: 140px;">Có công bố bản án ?<span class="batbuoc">(*)</span></div>
                                                            <asp:RadioButtonList ID="rdCongboBA"
                                                                runat="server" RepeatDirection="Horizontal">
                                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                            </asp:RadioButtonList>
                                                        </td>
                                                    </tr>--%>
                                                    <tr>
                                                        <td colspan="2">
                                                            <div style="float: left; line-height: 28px; width: 140px;">Có áp dụng Án lệ<span class="batbuoc">(*)</span></div>
                                                            <%--<asp:RadioButtonList ID="rdAnLe" runat="server"
                                                                RepeatDirection="Horizontal">
                                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                            </asp:RadioButtonList>--%>
                                                            <asp:DropDownList runat="server" ID="ddlCBBA_Anle" CssClass="user"></asp:DropDownList>
                                                        </td>
                                                        <td></td>
                                                        <td colspan="2">
                                                            <div style="float: left; line-height: 28px; width: 105px;">Án rút gọn<span class="batbuoc">(*)</span></div>
                                                            <asp:RadioButtonList ID="rdAnRutGon" runat="server"
                                                                RepeatDirection="Horizontal">
                                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                            </asp:RadioButtonList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <div style="float: left; line-height: 28px; width: 140px;">Bạo lực gia đình<span class="batbuoc">(*)</span> </div>
                                                            <asp:RadioButtonList ID="rdBaoLucGD" runat="server" RepeatDirection="Horizontal">
                                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                            </asp:RadioButtonList>
                                                        </td>
                                                        <td colspan="2">
                                                            <div style="float: left; line-height: 28px; width: 200px;">Án điểm hoặc xét xử lưu động<span class="batbuoc">(*)</span></div>

                                                            <asp:RadioButtonList ID="rdXetXuLuuDong" runat="server" RepeatDirection="Horizontal">
                                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                            </asp:RadioButtonList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <div style="float: left; line-height: 28px; width: 140px;">Luật sư</div>
                                                            <asp:RadioButtonList ID="rdLuatSu" runat="server" RepeatDirection="Horizontal" Enabled="false">
                                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                            </asp:RadioButtonList>
                                                        </td>
                                                        <td colspan="2">
                                                            <div style="float: left; line-height: 28px; width: 200px;">Người bào chữa khác</div>

                                                            <asp:RadioButtonList ID="rdNguoiBaochuaKhac" runat="server" RepeatDirection="Horizontal" Enabled="false">
                                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                            </asp:RadioButtonList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <div style="float: left; width: 100%; margin-bottom: 5px;">Tòa án áp dụng tội danh khác VKS truy tố<span class="batbuoc">(*)</span></div>

                                                            <div style="float: left;">
                                                                Nặng hơn
                                                            <asp:TextBox ID="txt_XXToiDanh_NangHon" runat="server"
                                                                CssClass="user align_right" onkeypress="return isNumber(event)"
                                                                Width="50px"></asp:TextBox>
                                                                (bị cáo)
                                                            </div>
                                                            <div style="float: left; margin-left: 10px;">
                                                                Nhẹ hơn
                                                            <asp:TextBox ID="txt_XXToiDanh_NheHon" runat="server"
                                                                CssClass="user align_right" onkeypress="return isNumber(event)"
                                                                Width="50px"></asp:TextBox>
                                                                (bị cáo)
                                                            </div>
                                                        </td>

                                                        <td colspan="2">
                                                            <div style="float: left; width: 100%; margin-bottom: 5px;">
                                                                Tòa án xét xử theo khoản khác VKS truy tố<span class="batbuoc">(*)</span>
                                                            </div>
                                                            <div style="float: left;">
                                                                Nặng hơn
                                                            <asp:TextBox ID="txt_XXKhoan_NangHon" runat="server"
                                                                CssClass="user align_right" onkeypress="return isNumber(event)"
                                                                Width="50px"></asp:TextBox>
                                                                (bị cáo)
                                                            </div>
                                                            <div style="float: left; margin-left: 10px;">
                                                                Nhẹ hơn
                                                            <asp:TextBox ID="txt_XXKhoan_NheHon" runat="server"
                                                                CssClass="user align_right" onkeypress="return isNumber(event)"
                                                                Width="50px"></asp:TextBox>
                                                                (bị cáo)
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <div style="float: left; width: 100%; margin-bottom: 5px;">
                                                                Tòa án áp dụng hình phạt khác theo đề nghị của VKS
                                                        <span class="batbuoc">(*)</span>
                                                            </div>
                                                            <div style="float: left;">
                                                                Nặng hơn
                                                            <asp:TextBox ID="txt_XXHinhPhat_NangHon" runat="server"
                                                                CssClass="user align_right" onkeypress="return isNumber(event)"
                                                                Width="50px"></asp:TextBox>(bị cáo)
                                                            </div>
                                                            <div style="float: left; margin-left: 10px;">
                                                                Nhẹ hơn
                                                        <asp:TextBox ID="txt_XXHinhPhat_NheHon" runat="server"
                                                            CssClass="user align_right" Width="50px"
                                                            onkeypress="return isNumber(event)"></asp:TextBox>(bị cáo)
                                                            </div>
                                                        </td>
                                                        <td colspan="2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">Tài sản chiếm đoạt  <span class="batbuoc">(*)</span>

                                                            <asp:TextBox ID="txtTSChiemDoat" runat="server"
                                                                onkeyup="javascript:this.value=Comma(this.value);"
                                                                onkeypress="return isNumber(event)" CssClass="user align_right"
                                                                Width="160px"></asp:TextBox>(VNĐ)</td>
                                                        <td colspan="2"><span style="margin-right: 21px">Tài sản thiệt hại  <span class="batbuoc">(*)</span></span>
                                                            <asp:TextBox ID="txtTSThietHai" runat="server" onkeyup="javascript:this.value=Comma(this.value);"
                                                                onkeypress="return isNumber(event)" CssClass="user align_right"
                                                                Width="160px"></asp:TextBox>(VNĐ)</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2"><span style="margin-right: 23px">Tài sản thu hồi <span class="batbuoc">(*)</span></span>
                                                            <asp:TextBox ID="txtTSThuHoi" runat="server"
                                                                onkeyup="javascript:this.value=Comma(this.value);"
                                                                onkeypress="return isNumber(event)" CssClass="user align_right"
                                                                Width="160px"></asp:TextBox>(VNĐ)</td>
                                                        <td colspan="2">Bồi thường thiệt hại <span class="batbuoc">(*)</span>
                                                            <asp:TextBox ID="txtBoiThuongTH" runat="server" onkeyup="javascript:this.value=Comma(this.value);"
                                                                onkeypress="return isNumber(event)" CssClass="user align_right"
                                                                Width="160px"></asp:TextBox>(VNĐ)</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                                    </tr>
                                                    <tr id="row_tucach_phapnhan_tm" runat="server">
                                                        <td style="width: 200px;">Pháp nhân thương mại có vốn góp nhà nước<span class="batbuoc">(*)</span></td>
                                                        <td>
                                                            <asp:RadioButtonList ID="rdPNTM_NhaNuoc"
                                                                runat="server" RepeatDirection="Horizontal">
                                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                            </asp:RadioButtonList></td>
                                                        <td style="width: 200px;">Pháp nhân thương mại có vốn đầu tư nước ngoài<span class="batbuoc">(*)</span></td>
                                                        <td>
                                                            <asp:RadioButtonList ID="rdPNTM_NuocNgoai"
                                                                runat="server" RepeatDirection="Horizontal">
                                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                            </asp:RadioButtonList></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 200px;">Vi phạm hạn tạm giam trong giai đoạn xét xử<span class="batbuoc">(*)</span></td>
                                                        <td>
                                                            <asp:RadioButtonList ID="rdViPhamHanTamGiam"
                                                                runat="server" RepeatDirection="Horizontal"
                                                                AutoPostBack="true" OnSelectedIndexChanged="rdViPhamHanTamGiam_SelectedIndexChanged">
                                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                            </asp:RadioButtonList></td>
                                                        <asp:Panel ID="pnViPham" runat="server" Enabled="false">
                                                            <td colspan="2">
                                                                <div style="float: left; width: 58px; line-height: 22px;">Số bị cáo</div>
                                                                <asp:TextBox ID="txtViPham_SoBiCao" runat="server"
                                                                    onkeypress="return isNumber(event)" CssClass="user align_right"
                                                                    Width="102px"></asp:TextBox>
                                                            </td>
                                                        </asp:Panel>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="col1">Tòa án quyết định phục hồi vụ án<span class="batbuoc">(*)</span></td>
                                                        <td class="col2">
                                                            <asp:RadioButtonList ID="rdIsPhucHoi"
                                                                runat="server" RepeatDirection="Horizontal"
                                                                AutoPostBack="true" OnSelectedIndexChanged="rdIsPhucHoi_SelectedIndexChanged">
                                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                            </asp:RadioButtonList>
                                                        </td>
                                                        <asp:Panel ID="pnPhucHoi" runat="server" Enabled="false">
                                                            <td colspan="2">
                                                                <div style="float: left; width: 58px; line-height: 22px;">Số bị cáo</div>
                                                                <asp:TextBox ID="txtPhucHoi_SoBiCao" runat="server"
                                                                    onkeypress="return isNumber(event)" CssClass="user align_right"
                                                                    Width="102px"></asp:TextBox>
                                                            </td>
                                                        </asp:Panel>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="col1">Khởi tố vụ án tại phiên tòa<span class="batbuoc">(*)</span></td>
                                                        <td class="col2">
                                                            <asp:RadioButtonList ID="rdKhoiTo"
                                                                runat="server" RepeatDirection="Horizontal"
                                                                AutoPostBack="true" OnSelectedIndexChanged="rdKhoiTo_SelectedIndexChanged">
                                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                            </asp:RadioButtonList>
                                                        </td>
                                                        <asp:Panel ID="pnKhoiTo" runat="server" Enabled="false">
                                                            <td colspan="2">
                                                                <div style="float: left; width: 58px; line-height: 22px;">Số bị cáo</div>
                                                                <asp:TextBox ID="txtKhoiTo_SoBiCao" runat="server"
                                                                    onkeypress="return isNumber(event)" CssClass="user align_right"
                                                                    Width="102px"></asp:TextBox>
                                                            </td>
                                                        </asp:Panel>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Vụ án trả hồ sơ nhưng VKS không chấp nhận yêu cầu của Tòa án<span class="batbuoc">(*)</span></td>
                                                        <td>
                                                            <asp:RadioButtonList ID="rdTraAn_VKSKoNhan"
                                                                runat="server" RepeatDirection="Horizontal">
                                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                            </asp:RadioButtonList>
                                                        </td>
                                                        <td style="width: 280px;">Kiến nghị sửa chữa thiếu sót, vi phạm trong công tác quản lý<span class="batbuoc">(*)</span></td>
                                                        <td>
                                                            <asp:RadioButtonList ID="rdViPham_CtacQuanLy"
                                                                runat="server" RepeatDirection="Horizontal">
                                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                            </asp:RadioButtonList>
                                                        </td>
                                                    </tr>
                                                    <!----------------------------------------->
                                                    <tr>
                                                        <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Tòa án tiến hành xác minh, thu thập, bổ sung chứng cứ<span class="batbuoc">(*)</span></td>
                                                        <td>
                                                            <asp:RadioButtonList ID="rdToaAn_XacMinh" OnSelectedIndexChanged="rdToaAn_XacMinh_SelectedIndexChanged"
                                                                runat="server" RepeatDirection="Horizontal" AutoPostBack="true">
                                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                            </asp:RadioButtonList>
                                                        </td>
                                                        <asp:Panel ID="rdKhongBoSungDuoc" runat="server" Visible="false">
                                                            <td>Tòa án tiến hành xác minh, thu thập chứng cứ khi đã yêu cầu mà VKS không bổ sung được
                                                            <span class="batbuoc">(*)</span></td>
                                                            <td>
                                                                <asp:RadioButtonList ID="rdToaAn_KoXacMinh"
                                                                    runat="server" RepeatDirection="Horizontal">
                                                                    <asp:ListItem Value="0">Không</asp:ListItem>
                                                                    <asp:ListItem Value="1">Có</asp:ListItem>
                                                                </asp:RadioButtonList>
                                                            </td>
                                                        </asp:Panel>

                                                    </tr>
                                                    <tr>
                                                        <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                                    </tr>
                                                    <!----------------------------------------->
                                                    <tr>
                                                        <td>Tòa án yêu cầu VKS bổ sung tài liệu, chứng cứ<span class="batbuoc">(*)</span></td>
                                                        <td>
                                                            <asp:RadioButtonList ID="rdToaAn_BSTaiLieu"
                                                                runat="server" RepeatDirection="Horizontal">
                                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                            </asp:RadioButtonList>
                                                        </td>
                                                    </tr>
                                                    <!----------------------------------------->
                                                    <tr>
                                                        <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Tòa án đề nghị các cơ quan áp dụng các biện pháp bảo vệ<span class="batbuoc">(*)</span></td>
                                                        <td>
                                                            <asp:RadioButtonList ID="rdToaAnApDungBaoVe" OnSelectedIndexChanged="rdToaAnApDungBaoVe_SelectedIndexChanged" AutoPostBack="true"
                                                                runat="server" RepeatDirection="Horizontal">
                                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                            </asp:RadioButtonList></td>
                                                        <asp:Panel ID="pnBPBV" runat="server" Enabled="false">
                                                            <td colspan="2">
                                                                <div style="float: left; width: 130px; line-height: 22px;">Số bị hại được đề nghị</div>
                                                                <asp:TextBox ID="txtSoBiHai" runat="server"
                                                                    onkeypress="return isNumber(event)" CssClass="user align_right"
                                                                    Width="102px"></asp:TextBox>
                                                            </td>
                                                        </asp:Panel>
                                                    </tr>
                                                    <!----------------------------------------->
                                                    <tr>
                                                        <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                                    </tr>

                                                    <tr>
                                                        <td>Xét xử lại phần xử lý vật chứng và trách nhiệm dân sự <span class="batbuoc">(*)</span></td>
                                                        <td>
                                                            <asp:RadioButtonList ID="rdXuLyVatChung" OnSelectedIndexChanged="rdXuLyVatChung_SelectedIndexChanged" AutoPostBack="true"
                                                                runat="server" RepeatDirection="Horizontal">
                                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                            </asp:RadioButtonList></td>
                                                        <asp:Panel ID="pnXLVC" runat="server" Enabled="false">
                                                            <td colspan="2">
                                                                <div style="float: left; width: 130px; line-height: 22px;">Số bị cáo</div>
                                                                <asp:TextBox ID="txtSoBiCao" runat="server"
                                                                    onkeypress="return isNumber(event)" CssClass="user align_right"
                                                                    Width="102px"></asp:TextBox>
                                                            </td>
                                                        </asp:Panel>
                                                    </tr>
                                                    <!----------------------------------------->

                                                    <tr>
                                                        <td rowspan="2">Vụ án quá hạn luật định<span class="batbuoc">(*)</span></td>
                                                        <td rowspan="2">
                                                            <asp:RadioButtonList ID="rdVuAnQuaHan" AutoPostBack="true"
                                                                runat="server" RepeatDirection="Horizontal"
                                                                OnSelectedIndexChanged="rdVuAnQuaHan_SelectedIndexChanged">
                                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                            </asp:RadioButtonList>
                                                        </td>

                                                        <td colspan="2">
                                                            <asp:Panel ID="pnNNQuanHan" runat="server" Visible="false">
                                                                <asp:RadioButtonList ID="rdNNQuaHan" runat="server"
                                                                    RepeatDirection="Horizontal">
                                                                    <asp:ListItem Value="0">Nguyên nhân chủ quan </asp:ListItem>
                                                                    <asp:ListItem Value="1">Nguyên nhân khách quan </asp:ListItem>
                                                                </asp:RadioButtonList>
                                                            </asp:Panel>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6" style="text-align: center">
                                        <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                                            <asp:Literal ID="lttMsgBanAn" runat="server"></asp:Literal>
                                        </div>
                                        <asp:Button ID="cmdUpdateBanAnST" runat="server" CssClass="buttoninput"
                                            Text="Lưu bản án sơ thẩm" OnClick="cmdUpdateBanAnST_Click"
                                            OnClientClick="return ValidData();" />
                                        <asp:Button ID="cmdHuyBanAn" runat="server" CssClass="buttoninput"
                                            Text="Xóa bản án" OnClick="cmdHuyBanAn_Click"
                                            OnClientClick="return confirm('Bạn thực sự muốn xóa bản án này? ');" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <asp:Panel ID="pnAnPhi" runat="server">
                        <div class="boxchung">
                            <h4 class="tleboxchung">Quyết định và hình phạt</h4>
                            <div class="boder" style="padding: 10px;">
                                <div class="zone_ghichu" style="display: none;">
                                    <b>Ghi chú</b><br />
                                    <b>1. Lưu án phí cho bị cáo</b><br />
                                    1.1. Nhập mức án phí cho bị cáo<br />
                                    1.2. Ấn chọn "Lưu" để cập nhật thông tin<br />
                                    <b>2. Cập nhật quyết định & điều luật áp dụng cho bị cáo</b><br />
                                    2.1. Chọn bị cáo<br />
                                    2.2. Chọn "Điều luật áp dụng" của bị cáo được chọn<br />
                                </div>
                                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                                    <asp:Literal ID="lttMsgAnPhi" runat="server"></asp:Literal>
                                </div>
                                <div style="">
                                    <asp:Panel runat="server" ID="pndata">
                                        <div class="phantrang">
                                            <div class="sobanghi">
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
                                        </div>

                                        <asp:Repeater ID="rpt" runat="server"
                                            OnItemCommand="rpt_ItemCommand"
                                            OnItemDataBound="rpt_ItemDataBound">
                                            <HeaderTemplate>
                                                <table class="table2" width="100%" border="1">
                                                    <tr class="header">
                                                        <td style="width: 42px;">
                                                            <div align="center"><strong>TT</strong></div>
                                                        </td>
                                                        <td width="20%">
                                                            <div align="center"><strong>Bị cáo</strong></div>
                                                        </td>
                                                        <td width="80px">
                                                            <div align="center"><strong>Tham gia phiên tòa</strong></div>
                                                        </td>
                                                        <td width="60px">
                                                            <div align="center"><strong>Án phí (Đơn vị là đồng)</strong></div>
                                                        </td>

                                                        <td width="100px">
                                                            <div align="center"><strong>Ngày nhận bản án</strong></div>
                                                        </td>
                                                         <%--GTEL-DUCPH 13-09-2025 thêm Ngày Hiệu Lực--%>
                                                        <td width="100px">
                                                            <div align="center"><strong>Ngày hiệu lực</strong></div>
                                                        </td>
                                                        <td width="90px">
                                                            <div align="center"><strong>Hình phạt tổng hợp</strong></div>
                                                        </td>
                                                        <td>
                                                            <div align="center"><strong>Điều luật áp dụng</strong></div>
                                                        </td>
                                                    </tr>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr>
                                                    <td>
                                                        <asp:HiddenField ID="hddBiCao" runat="server" Value='<%#Eval("ID") %>' />
                                                        <%# Eval("STT") %></td>
                                                    <td><%#Eval("HoTen") %></td>
                                                    <td>
                                                        <div style="text-align: center;">
                                                            <asp:CheckBox ID="chkThamGiaPhienToa" runat="server"
                                                                Checked='<%# (Convert.ToInt16(Eval("IsThamGiaPhienToa"))>0)? true:false %>' />
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtAnPhi" runat="server" Text='<%#Eval("AnPhi") %>'
                                                            onkeyup="javascript:this.value=Comma(this.value);" onkeypress="return isNumber(event)"
                                                            CssClass="user align_right"></asp:TextBox></div>
                                                    </td>

                                                    <td>
                                                        <div style="text-align: center;">
                                                            <asp:TextBox ID="txtNgaynhanbanan" runat="server" AutoPostBack="true" OnTextChanged="txtNgaynhanbanan_TextChanged"
                                                                Text='<%# string.Format("{0:dd/MM/yyyy}",Eval("NgayNhanBanAn")) %>' CssClass="user" Width="70px"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="txtNgaynhanbanan_CalendarExtender" runat="server" TargetControlID="txtNgaynhanbanan" Format="dd/MM/yyyy" />
                                                            <cc1:MaskedEditExtender ID="txtNgaynhanbanan_MaskedEditExtender3" runat="server" TargetControlID="txtNgaynhanbanan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" Century="2000" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                                                        </div>
                                                    </td>
                                                     <%--GTEL-DUCPH 13-09-2025 thêm Ngày Hiệu Lực--%>
                                                    <td>
                                                        <div style="text-align: center;">
                                                            <asp:TextBox ID="txtNgayHieuLuc" runat="server" Enabled="false"
                                                                Text='<%# string.Format("{0:dd/MM/yyyy}",Eval("NgayHieuLuc")) %>' CssClass="user" Width="70px"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="txtNgayHieuLuc_CalendarExtender" runat="server" TargetControlID="txtNgayHieuLuc" Format="dd/MM/yyyy" />
                                                            <cc1:MaskedEditExtender ID="txtNgayHieuLuc_MaskedEditExtender" runat="server" TargetControlID="txtNgayHieuLuc" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" Century="2000" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div style="text-align: center;">
                                                            <asp:Label ID="lblTHtoidanh" runat="server" Text=""></asp:Label>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <asp:Panel ID="lnLinkToiDanh" runat="server" Visible='<%# Visible_BTN_DieuLuatApDung(Eval("ID")) %>'>
                                                            <asp:HiddenField ID="hddDaDongBo" runat="server" Value="0" />
                                                            <div align="center">
                                                                <%--<a href="javascript:;" onclick="popupChonToiDanh(<%#Eval("ID") %>)" class="link_ds">Điều luật áp dụng</a>--%>
                                                                <%--//GTEl-DUCPH 22-09-2025 Truyền thêm hddDaDongBO vao để check cho hiển popup hay không--%>
                                                                <a href="javascript:;" onclick="popupChonToiDanh(<%#Eval("ID") %>,'<%# ((HiddenField)Container.FindControl("hddDaDongBo")).ClientID %>')" class="link_ds">Điều luật áp dụng</a>
                                                                
                                                            </div>
                                                        </asp:Panel>
                                                    </td>
                                                    <td style="display: none;">
                                                        <asp:HiddenField ID="hddToaGiaiQuyetID" runat="server" Value='<%#Eval("TOA_GIAIQUYET_ID") %>' />
                                                    </td>
                                                </tr>
                                            </ItemTemplate>

                                            <FooterTemplate></table></FooterTemplate>
                                        </asp:Repeater>

                                        <div class="phantrang_bottom">
                                            <div class="sobanghi">
                                                <asp:Button ID="cmdUpdateAnPhi" runat="server" CssClass="buttoninput"
                                                    Text="Lưu thông tin" OnClick="cmdUpdateAnPhi_Click" />
                                                <asp:Button ID="cmdReloadParent" runat="server" CssClass="buttoninput" Style="display: none" OnClick="cmdReloadParent_Click" />
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
                                        </div>
                                    </asp:Panel>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnQDVV" runat="server" Visible="false" ChildrenAsTriggers="true" ClienIDMode="AutoID">
        <div class="box">
            <div class="box_nd">
                <div class="boxchung">
                    <h4 class="tleboxchung">THÔNG TIN BA/QĐ</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td colspan="4">
                                    <asp:RadioButtonList ID="rdbPanelQD" runat="server" RepeatDirection="Horizontal" Font-Bold="true" AutoPostBack="true" OnSelectedIndexChanged="rdbPanelQD_SelectedIndexChanged">
                                        <asp:ListItem Value="1" Text="Bản án" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Quyết định"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td class="table_edit_col1" style="width: 142px;">Thụ lý<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:DropDownList ID="dropThuLyQD" CssClass="chosen-select" runat="server" Width="628" AutoPostBack="true" OnSelectedIndexChanged="dropThuLyQD_SelectedIndexChanged"></asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>Tên quyết định<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:DropDownList ID="ddlQuyetdinh" CssClass="chosen-select" runat="server" Width="650px" AutoPostBack="True" ClientIDMode="AutoID" OnSelectedIndexChanged="ddlQuyetdinh_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td class="QDVACol1">Ngày mở phiên tòa</td>
                                <td class="QDVACol2">
                                    <asp:TextBox ID="txtNgayMoPhienToaQD" runat="server" CssClass="user" Width="100px"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayMoPhienToaQD" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayMoPhienToaQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td class="QDVACol3">Địa điểm</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtDiaDiemQD" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                </td>
                            </tr>
                            <asp:Panel ID="pnLyDo" runat="server">
                                <tr>
                                    <td>Lý do<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddlLydo" CssClass="chosen-select" runat="server" Width="650px"></asp:DropDownList>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <asp:Panel ID="pnCBQD" Visible="true" runat="server">
                                <tr>
                                    <td>Có công bố quyết định?<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:RadioButtonList ID="rdCongBoQD" AutoPostBack="true" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                            </asp:Panel>
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
                                        <asp:TextBox ID="txtNguoiKyQD" CssClass="user" Enabled="false" runat="server"
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
                                <td class="QDVACol3">Ngày quyết định <span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgayQD" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
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
                                    <cc1:AsyncFileUpload ID="AsyncFileUpLoadQD" CssClass="floatF" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern"
                                        OnClientUploadStarted="onUploadStartQD"
                                        OnClientUploadComplete="onUploadCompleteQD"
                                        OnUploadedComplete="AsyncFileUpLoad_UploadedCompleteQD"
                                        ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                    <%--<asp:Image ID="Image1" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />--%>
                                    <asp:LinkButton ID="lbtAddFile" CssClass="linkAddFile" Visible="false" runat="server" Text="Thêm tệp đính kèm"></asp:LinkButton>
                                    <div id="loadingIndicatorQD" style="display: none; color: red;">Đang tải file...</div>
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
                                    <asp:LinkButton ID="lbtDownload" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownload_Click"></asp:LinkButton></td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="truong">
                    <table class="table1">
                        <tr>

                            <td colspan="2" style="text-align: center;">
                                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                                    <asp:Literal ID="lttMsgQuyetDinh" runat="server"></asp:Literal>
                                </div>
                                <asp:Button ID="btnUpdate" runat="server" CssClass="buttoninput"
                                    Text="Lưu" OnClientClick="return ValidInputData();" OnClick="btnUpdate_Click" />
                                <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div>
                                    <asp:HiddenField ID="hddidQD" runat="server" Value="0" />
                                    <asp:HiddenField ID="hddNguoiKyTxtID" runat="server" Value="0" />
                                    <asp:HiddenField ID="hddNguoiKyQDID" runat="server" Value="0" />
                                    <asp:Label runat="server" ID="lbThongBaoQD" ForeColor="Red"></asp:Label>
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
    </asp:Panel>
    <script type="text/javascript">
        function ValidData() {
            var NgaySoSanh = '<%= NgaySoSanh%>';
            var txtNgayMoPhienToa = document.getElementById('<%=txtNgayMoPhienToa.ClientID%>');
            if (!CheckDateTimeControl(txtNgayMoPhienToa, 'Ngày mở phiên tòa'))
                return false;

            var txtDiaDiem = document.getElementById('<%=txtDiaDiem.ClientID%>');
            if (!Common_CheckEmpty(txtDiaDiem.value)) {
                alert('Bạn chưa chọn "Địa điểm".Hãy kiểm tra lại!');
                txtDiaDiem.focus();
                return false;
            }

            var txtSoBanAn = document.getElementById('<%=txtSoBanAn.ClientID%>');
            if (!Common_CheckEmpty(txtSoBanAn.value)) {
                alert('Bạn chưa nhập số bản án.Hãy kiểm tra lại!');
                txtSoBanAn.focus();
                return false;
            }

            var txtNgayBanAn = document.getElementById('<%=txtNgayBanAn.ClientID%>');
            if (!CheckDateTimeControl(txtNgayBanAn, 'Ngày bản án'))
                return false;

            var hddNguoiKyID = document.getElementById('<%=hddNguoiKyID.ClientID%>');
            var txtNguoiKy = document.getElementById('<%=txtNguoiKy.ClientID%>');
            if (!Common_CheckEmpty(hddNguoiKyID.value)) {
                alert('Bạn chưa chọn mục "Người ký". Hãy kiểm tra lại!');
                txtNguoiKy.focus();
                return false;
            }

    <%--    var msg = "";
        var rdAnLe = document.getElementById('<%=rdAnLe.ClientID%>');
        msg = 'Mục "Có áp dụng Án lệ" bắt buộc phải chọn. Hãy kiểm tra lại!';
        if (!CheckChangeRadioButtonList(rdAnLe, msg))
            return false;--%>

            var rdAnRutGon = document.getElementById('<%=rdAnRutGon.ClientID%>');
            msg = 'Mục "Án rút gọn" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdAnRutGon, msg))
                return false;

            var rdBaoLucGD = document.getElementById('<%=rdBaoLucGD.ClientID%>');
            msg = 'Mục "Bạo lực gia đình" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdBaoLucGD, msg))
                return false;
            var txt_XXToiDanh_NangHon = document.getElementById('<%=txt_XXToiDanh_NangHon.ClientID%>');
            if (!Common_CheckEmpty(txt_XXToiDanh_NangHon.value)) {
                alert('Mục "Nặng hơn" bắt buộc phải chọn. Hãy kiểm tra lại!');
                txt_XXToiDanh_NangHon.focus();
                return false;
            }

            var txt_XXToiDanh_NheHon = document.getElementById('<%=txt_XXToiDanh_NheHon.ClientID%>');
            if (!Common_CheckEmpty(txt_XXToiDanh_NheHon.value)) {
                alert('Mục "Nhẹ hơn" bắt buộc phải chọn. Hãy kiểm tra lại!');
                txt_XXToiDanh_NheHon.focus();
                return false;
            }

            var txt_XXKhoan_NangHon = document.getElementById('<%=txt_XXKhoan_NangHon.ClientID%>');
            if (!Common_CheckEmpty(txt_XXKhoan_NangHon.value)) {
                alert('Mục "Nặng hơn" bắt buộc phải chọn. Hãy kiểm tra lại!');
                txt_XXKhoan_NangHon.focus();
                return false;
            }

            var txt_XXKhoan_NheHon = document.getElementById('<%=txt_XXKhoan_NheHon.ClientID%>');
            if (!Common_CheckEmpty(txt_XXKhoan_NheHon.value)) {
                alert('Mục "Nhẹ hơn" bắt buộc phải chọn. Hãy kiểm tra lại!');
                txt_XXKhoan_NheHon.focus();
                return false;
            }

            var txt_XXHinhPhat_NangHon = document.getElementById('<%=txt_XXHinhPhat_NangHon.ClientID%>');
            if (!Common_CheckEmpty(txt_XXHinhPhat_NangHon.value)) {
                alert('Mục "Nặng hơn" bắt buộc phải chọn. Hãy kiểm tra lại!');
                txt_XXHinhPhat_NangHon.focus();
                return false;
            }

            var txt_XXHinhPhat_NheHon = document.getElementById('<%=txt_XXHinhPhat_NheHon.ClientID%>');
            if (!Common_CheckEmpty(txt_XXHinhPhat_NheHon.value)) {
                alert('Mục "Nhẹ hơn" bắt buộc phải chọn. Hãy kiểm tra lại!');
                txt_XXHinhPhat_NheHon.focus();
                return false;
            }

            var txtTSChiemDoat = document.getElementById('<%=txtTSChiemDoat.ClientID%>');
            if (!Common_CheckEmpty(txtTSChiemDoat.value)) {
                alert('Mục "Tài sản chiếm đoạt" bắt buộc phải chọn. Hãy kiểm tra lại!');
                txtTSChiemDoat.focus();
                return false;
            }

            var txtTSThietHai = document.getElementById('<%=txtTSThietHai.ClientID%>');
            if (!Common_CheckEmpty(txtTSThietHai.value)) {
                alert('Mục "Tài sản thiệt hại" bắt buộc phải chọn. Hãy kiểm tra lại!');
                txtTSThietHai.focus();
                return false;
            }

            var txtTSThuHoi = document.getElementById('<%=txtTSThuHoi.ClientID%>');
            if (!Common_CheckEmpty(txtTSThuHoi.value)) {
                alert('Mục "Tài sản thu hồi" bắt buộc phải chọn. Hãy kiểm tra lại!');
                txtTSThuHoi.focus();
                return false;
            }

            var txtBoiThuongTH = document.getElementById('<%=txtBoiThuongTH.ClientID%>');
            if (!Common_CheckEmpty(txtBoiThuongTH.value)) {
                alert('Mục "Bồi thường thiệt hại" bắt buộc phải chọn. Hãy kiểm tra lại!');
                txtBoiThuongTH.focus();
                return false;
            }

            var rdXetXuLuuDong = document.getElementById('<%=rdXetXuLuuDong.ClientID%>');
            msg = 'Mục "Án điểm hoặc xét xử lưu động" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdXetXuLuuDong, msg))
                return false;

        <%--var rdCongBoBA = document.getElementById('<%=rdCongboBA.ClientID%>');
        msg = 'Mục "Công bố bản án" bắt buộc phải chọn. Hãy kiểm tra lại!';
        if (!CheckChangeRadioButtonList(rdCongBoBA, msg))
            return false;--%>

    <%--var hddTuCachPN = document.getElementById('<%=hddTuCachPN.ClientID%>');
    if (hddTuCachPN && hddTuCachPN.value == "0") {
        var msg = '';

                return true;
            }
            function validate_CheckRadio() {
                var msg = "";
                <%--var rdAnLe = document.getElementById('<%=rdAnLe.ClientID%>');
                msg = 'Mục "Có áp dụng Án lệ" bắt buộc phải chọn. Hãy kiểm tra lại!';
                if (!CheckChangeRadioButtonList(rdAnLe, msg))
                    return false;--%>
<%--        var rdPNTM_NhaNuoc = document.getElementById('<%=rdPNTM_NhaNuoc.ClientID%>');
        if (!rdPNTM_NhaNuoc) {
            alert('Không tìm thấy phần tử rdPNTM_NhaNuoc');
            return false;
        }
        msg = 'Mục "Pháp nhân thương mại có vốn góp nhà nước" bắt buộc phải chọn. Hãy kiểm tra lại!';
        if (!CheckChangeRadioButtonList(rdPNTM_NhaNuoc, msg))
            return false;--%>

<%--        var rdPNTM_NuocNgoai = document.getElementById('<%=rdPNTM_NuocNgoai.ClientID%>');
        if (!rdPNTM_NuocNgoai) {
            alert('Không tìm thấy phần tử rdPNTM_NuocNgoai');
            return false;
        }
        msg = 'Mục "Pháp nhân thương mại có vốn đầu tư nước ngoài" bắt buộc phải chọn. Hãy kiểm tra lại!';
        if (!CheckChangeRadioButtonList(rdPNTM_NuocNgoai, msg))
            return false;--%>

            var rdToaAnApDungBaoVe = document.getElementById('<%=rdToaAnApDungBaoVe.ClientID%>');
            msg = 'Mục "Tòa án đề nghị các cơ quan áp dụng các biện pháp bảo vệ" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdToaAnApDungBaoVe, msg))
                return false;

            var rdViPhamHanTamGiam = document.getElementById('<%=rdViPhamHanTamGiam.ClientID%>');
            msg = 'Mục "Vi phạm hạn tạm giam trong giai đoạn xét xử" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdViPhamHanTamGiam, msg))
                return false;

            var rdIsPhucHoi = document.getElementById('<%=rdIsPhucHoi.ClientID%>');
            msg = 'Mục "Tòa án quyết định phục hồi vụ án" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdIsPhucHoi, msg))
                return false;

            var rdKhoiTo = document.getElementById('<%=rdKhoiTo.ClientID%>');
            msg = 'Mục "Khởi tố vụ án tại phiên tòa" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdKhoiTo, msg))
                return false;

            var rdTraAn_VKSKoNhan = document.getElementById('<%=rdTraAn_VKSKoNhan.ClientID%>');
            msg = 'Mục "Vụ án trả hồ sơ nhưng VKS không chấp nhận yêu cầu của Tòa án" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdTraAn_VKSKoNhan, msg))
                return false;

            var rdViPham_CtacQuanLy = document.getElementById('<%=rdViPham_CtacQuanLy.ClientID%>');
            msg = 'Mục "Kiến nghị sửa chữa thiếu sót, vi phạm trong công tác quản lý" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdViPham_CtacQuanLy, msg))
                return false;

            var rdToaAn_BSTaiLieu = document.getElementById('<%=rdToaAn_BSTaiLieu.ClientID%>');
            msg = 'Mục "Tòa án yêu cầu VKS bổ sung tài liệu, chứng cứ" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdToaAn_BSTaiLieu, msg))
                return false;

            var txtSoBiHai = document.getElementById('<%=txtSoBiHai.ClientID%>');
            var tongBiHai = <%= TongSoBiHai() %>;
            if (Common_CheckEmpty(txtSoBiHai.value) && txtSoBiHai.value > tongBiHai) {
                alert('Mục "Số bị hại được đề nghị" vượt quá số lượng. Hãy kiểm tra lại!');
                txtSoBiHai.focus();
                return false;
            }
            var rdToaAn_XacMinh = document.getElementById('<%=rdToaAn_XacMinh.ClientID%>');
            msg = 'Mục "Tòa án tiến hành xác minh, thu thập, bổ sung chứng cứ" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdToaAn_XacMinh, msg))
                return false;

            var rdToaAn_KoXacMinh = document.getElementById('<%=rdToaAn_KoXacMinh.ClientID%>');
            msg = 'Mục "Tòa án tiến hành xác minh, thu thập chứng cứ khi đã yêu cầu mà VKS không bổ sung được" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdToaAn_KoXacMinh, msg))
                return false;


            var rdVuAnQuaHan = document.getElementById('<%=rdVuAnQuaHan.ClientID%>');
            msg = 'Mục "Vụ án quá hạn" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdVuAnQuaHan, msg))
                return false;
            return true;
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
        function pageLoad(sender, args) {
            $(function () {

                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            });
        }
        function Loadds_bicao() {
            $("#<%= cmdReloadParent.ClientID %>").click();
        }
    </script>
    <script>
        /*GTEL - DUCPH 22 - 09 - 2025 Them bien hddDaDongBoId de check co hien popup hay khong*/
        function popupChonToiDanh(BiCanID, hddDaDongBoId) {
            var checkDaDongBo = document.getElementById(hddDaDongBoId).value;
            if (checkDaDongBo == '1') { // Nếu đã đồng bộ thì không hiện popup bắn thông báo
                alert("Bản án đã được đồng bộ thành công. Phải thu hồi đồng bộ trước khi chỉnh sửa!");
                return;
            }
            var BanAnID = document.getElementById('<%=hddID.ClientID%>').value;
            var link = "/QLAN/AHS/SoTham/BanAnST/popup/pToiDanh.aspx?aID=" + BanAnID + "&bID=" + BiCanID;
            var width = 900;
            var height = 650;
            PopupCenter(link, "Cập nhật điều luật áp dụng cho bị cáo", width, height);
        }
    </script>
    <script type="text/javascript">
        function onUploadStartQD(sender, args) {
            document.getElementById('loadingIndicatorQD').style.display = 'block';
            document.getElementById('<%= btnUpdate.ClientID %>').disabled = true;
        }

        function onUploadCompleteQD(sender, args) {
            document.getElementById('loadingIndicatorQD').style.display = 'none';
            document.getElementById('<%= btnUpdate.ClientID %>').disabled = false;
        }
        function onUploadStartBA(sender, args) {
            document.getElementById('loadingIndicatorBA').style.display = 'block';
            document.getElementById('<%= cmdUpdateBanAnST.ClientID %>').disabled = true;
        }

        function onUploadCompleteBA(sender, args) {
            document.getElementById('loadingIndicatorBA').style.display = 'none';
            document.getElementById('<%= cmdUpdateBanAnST.ClientID %>').disabled = false;
        }
    </script>
</asp:Content>


