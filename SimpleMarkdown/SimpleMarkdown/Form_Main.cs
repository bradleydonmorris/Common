using Markdig;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace SimpleMarkdown
{
	public partial class Form_Main : Form
	{
		private String _FilePath;
		private Boolean _IsWebViewInitialized = false;

		private Markdig.MarkdownPipeline _MarkdownPipeline { get; set; }

		public Form_Main()
		{
			this._MarkdownPipeline = new MarkdownPipelineBuilder()
				.UseAdvancedExtensions()
				.UseBootstrap()
				.UseFigures()
				.UsePipeTables()
				.UseGridTables()
				.UseTaskLists()
				.UseMediaLinks()
				.UseListExtras()
				.UseFooters()
				.UseDefinitionLists()
				.UseDiagrams()
				.UseCitations()
				.UseSoftlineBreakAsHardlineBreak()
				.Build();
			InitializeComponent();
		}

		private async void Form_Main_Load(Object sender, EventArgs e)
		{
			await InitializeAsync();
			this.WebView2_Markdown.Source = new("about:blank");
		}
		private async Task InitializeAsync()
		{
			await WebView2_Markdown.EnsureCoreWebView2Async(null);
		}

		private void WebView2_Markdown_CoreWebView2InitializationCompleted(Object sender, Microsoft.Web.WebView2.Core.CoreWebView2InitializationCompletedEventArgs e)
		{
			this._IsWebViewInitialized = true;
		}

		private void TextBox_Markdown_TextChanged(Object sender, EventArgs e)
		{
			if (this._IsWebViewInitialized)
			{
				WebView2_Markdown.Source = new("about:blank");
				WebView2_Markdown.NavigateToString("");
				WebView2_Markdown.NavigateToString(Markdig.Markdown.ToHtml(TextBox_Markdown.Text, this._MarkdownPipeline));
				WebView2_Markdown.Refresh();
			}
			if (
				!String.IsNullOrEmpty(this.TextBox_Markdown.Text)
				&& !String.IsNullOrEmpty(this._FilePath)
				&& File.Exists(this._FilePath)
			)
				File.WriteAllText(this._FilePath, this.TextBox_Markdown.Text);
		}

		private void TextBox_Markdown_DragDrop(Object sender, DragEventArgs e)
		{
			if (
				e.Data.GetDataPresent(DataFormats.FileDrop)
				&& e.Data.GetData(DataFormats.FileDrop) is String[] files
				&& files.Length > 0
			)
			{
				this._FilePath = files[0];
				this.TextBox_Markdown.Text = File.ReadAllText(this._FilePath);
			}
		}

		private void TextBox_Markdown_DragEnter(Object sender, DragEventArgs e)
		{
			if (
				e.Data.GetDataPresent(DataFormats.FileDrop)
				&& e.Data.GetData(DataFormats.FileDrop) is String[] files
				&& files.Length > 0
			)
				if (files[0].EndsWith(".md", StringComparison.CurrentCultureIgnoreCase))
					e.Effect = DragDropEffects.Copy;
				else
					e.Effect = DragDropEffects.None;
			else
				e.Effect = DragDropEffects.None;
		}
	}
}
