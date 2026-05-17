<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Hoagiai.aspx.cs" Inherits="WEB.GSTP.QLAN.ALD.Sotham.Hoagiai" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
    <style type="text/css">
        #ContentPlaceHolder1_AsyncFileUpLoad_ctl01 {
            width: 302px !important;
        }

            #ContentPlaceHolder1_AsyncFileUpLoad_ctl01 input[type=text] {
                width: 194px !important;
            }
            .TenFile_css{
                    color: inherit !important;
            }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Thông báo về hòa giải</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td style="width: 115px;">Loại thông báo</td>
                            <td style="width: 300px;">
                                <asp:DropDownList ID="ddlLoaithongbao" CssClass="chosen-select" runat="server" Width="300px">
                                    <asp:ListItem Value="1" Text="Thông báo hòa giải"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Thông báo hoãn hòa giải"></asp:ListItem>
                                </asp:DropDownList></td>
                            <td style="width: 115px;"></td>
                            <td></td>
                        </tr>

                        <tr>
                            <td>Số thông báo<span class="batbuoc">(*)</span></td>
                            <td colspan="3">
                                <asp:TextBox ID="txtSothongbao" CssClass="user" runat="server" Width="90px" MaxLength="250"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>Ngày thông báo<span class="batbuoc">(*)</span></td>
                            <td colspan="3">
                                <asp:TextBox ID="txtNgaythongbao" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaythongbao" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaythongbao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>

                        </tr>
                        <tr>
                            <td>Người ký</td>
                            <td>
                                <asp:DropDownList ID="ddlNguoiky" CssClass="chosen-select" runat="server" Width="300px">
                                </asp:DropDownList>
                            </td>
                            <td></td>
                            <td></td>
                        </tr>

                        <tr>
                            <td>Tệp đính kèm</td>
                            <td>
                                <asp:HiddenField ID="hddFilePath" runat="server" />
                                <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                    ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                            </td>
                            <td colspan="2">
                                <asp:LinkButton ID="lbtDownload" Visible="false" runat="server" Text="Tải tệp đính kèm" OnClick="lbtDownload_Click"></asp:LinkButton></td>
                        </tr>
                    </table>
                </div>
            </div>

            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2" align="center">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnUpdate_Click" />

                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div>
                                <asp:HiddenField ID="hddid" runat="server" Value="0" />
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                            </div>

                            <asp:Panel runat="server" ID="pndata" Visible="false">
                                <div class="phantrang">
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
                                </div>
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:TemplateColumn HeaderStyle-Width="30px" ItemStyle-Width="30px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                TT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Container.DataSetIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Loại thông báo
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TENLOAITHONGBAO") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Số
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("SO") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="NGAY" HeaderText="Ngày thông báo" HeaderStyle-Width="95px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="200px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Người ký
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("HOTEN") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="NGUOITAO" HeaderText="Người tạo" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYTAO" HeaderText="Ngày tạo" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>
                                        <%--<asp:TemplateColumn HeaderStyle-HorizontalAlign="Center"  HeaderStyle-Width="65px">
                                    <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lblDownload" runat="server" Text='<%#Eval("TENFILE") %>' CausesValidation="false" CommandName="Download"
                                            CommandArgument='<%#Eval("ID") %>' CssClass="TenFile_css"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateColumn>--%>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                    <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                    <ItemTemplate >
                                        <asp:ImageButton ID="lblDownload" ImageUrl="~/UI/img/ghim.png" runat="server" CausesValidation="false" CommandName="Download"
                                            CommandArgument='<%#Eval("ID") %>' ToolTip='<%#Eval("TENFILE")%>' />
                                        <%--<asp:LinkButton ID="lblDownload" runat="server" Text='<%#Eval("TENFILE") %>'  CssClass="TenFile_css"></asp:LinkButton>--%>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%--<asp:LinkButton ID="lblDownload" runat="server" Text="Tải về" CausesValidation="false" CommandName="Download" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                &nbsp;&nbsp;--%>
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                &nbsp;&nbsp;
                                                <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee" CommandName="Xoa" 
                                                    CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="TOA_GIAIQUYET_ID" Visible="false"></asp:BoundColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                                <div class="phantrang">
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
                                </div>
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }

        }
    </script>
</asp:Content>
